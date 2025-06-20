using Dapper;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExpedientesController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;

        public ExpedientesController(IConfiguration configuration,IGeneral general)
        {
            _configuration = configuration;
            _general = general;
        }

        [HttpPost]
        [Route("RegistrarArchivo/{Id_Familia}")]
        public IActionResult RegistrarArchivo(/*[FromForm]*/ IFormFile archivo, long Id_Familia)
        {
            if (!_general.EsAdministrador(User.Claims))
            {
                return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
            }
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

                using (var connection = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    connection.Open();
                    var result = connection.Execute("RegistrarArchivo", new
                    {
                        nuevoArchivo.Nombre,
                        nuevoArchivo.Tipo,
                        nuevoArchivo.Ruta,
                        Id_Familia
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
            if (!_general.EsAdministrador(User.Claims))
            {
                return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
            }
            using (var connection = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                connection.Open();

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

        [HttpGet]
        [Route("ObtenerExpedientes")]
        public IActionResult ObtenerExpedientes(long Id_Expediente)
        {
            try
            {

                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }
                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    connection.Open();

                    var result = connection.Query<ExpedientesModel>("ObtenerExpedientes", new { Id_Expediente }, commandType: CommandType.StoredProcedure).ToList();
                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (MySqlException MySqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = MySqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
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
