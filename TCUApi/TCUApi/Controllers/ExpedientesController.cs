using Dapper;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using TCUApi.Model;

namespace TCUApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExpedientesController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public ExpedientesController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("RegistrarArchivo")]
        public IActionResult RegistrarArchivo(/*[FromForm]*/ IFormFile archivo)
        {
            try
            {
                if (archivo == null || archivo.Length == 0)
                {
                    return BadRequest(new { error = "No se ha seleccionado un archivo" });
                }

                
                var rutaCarpeta = Path.Combine(Directory.GetCurrentDirectory(), "ArchivosSubidos");
                if (!Directory.Exists(rutaCarpeta))
                {
                    Directory.CreateDirectory(rutaCarpeta);
                }
                

                var rutaArchivo = Path.Combine(rutaCarpeta, archivo.FileName);
                var rutaEncriptada = Encrypt(rutaArchivo);

                using (var stream = new FileStream(rutaArchivo, FileMode.Create))
                {
                    archivo.CopyTo(stream);
                }

                var nuevoArchivo = new
                {
                    Nombre = archivo.FileName,
                    Tipo = archivo.ContentType,
                    Ruta = rutaEncriptada
                };

                // Registrar el archivo en la base de datos
                using (var connection = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    var result = connection.Execute("RegistrarArchivo", new
                    {
                        nuevoArchivo.Nombre,
                        nuevoArchivo.Tipo,
                        nuevoArchivo.Ruta
                    });

                    var respuesta = new RespuestaModel();
                    if (result > 0)
                    {
                        respuesta.Indicador = true;
                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Error al registrar el archivo";
                    }

                    return Ok(respuesta);
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }


        [HttpGet]
        [Route("DescargarArchivo/{id}")]
        public IActionResult DescargarArchivo(int id)
        {
            using (var connection = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                var archivo = connection.QueryFirstOrDefault<dynamic>("DescargarArchivo", new { Id_Archivo = id });
                var rutaDecrypted = Decrypt(archivo!.Ruta);

                if (archivo == null || !System.IO.File.Exists(rutaDecrypted))
                {
                    return NotFound(new { error = "Archivo no encontrado" });
                }

                var bytes = System.IO.File.ReadAllBytes(rutaDecrypted);
                return File(bytes, archivo!.Tipo, archivo.Nombre);
            }
        }





        private string Encrypt(string texto)
        {
            byte[] iv = new byte[16];
            byte[] array;

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(_configuration.GetSection("Variables:SecretKey").Value!);
                aes.IV = iv;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter streamWriter = new StreamWriter(cryptoStream))
                        {
                            streamWriter.Write(texto);
                        }

                        array = memoryStream.ToArray();
                    }
                }
            }

            return Convert.ToBase64String(array);
        }

        private string Decrypt(string texto)
        {
            byte[] iv = new byte[16];
            byte[] buffer = Convert.FromBase64String(texto);

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(_configuration.GetSection("Variables:SecretKey").Value!);
                aes.IV = iv;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream(buffer))
                {
                    using (CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader streamReader = new StreamReader(cryptoStream))
                        {
                            return streamReader.ReadToEnd();
                        }
                    }
                }
            }
        }
    }
}
