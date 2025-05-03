using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosEsperaController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;

        public UsuariosEsperaController(IConfiguration configuration, IGeneral general)
        {
            _configuration = configuration;
            _general = general;
        }
        [HttpPut]
        [Route("AccesoUsuarios")]
        public IActionResult AccesoUsuarios([FromBody] UsuarioModel model)  
        {
            string mensaje = model.mensaje!;  

            if (!_general.EsAdministrador(User.Claims))
            {
                return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
            }

            using (var context = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                var nombreEstado = context.ExecuteScalar<string>("AccesoUsuarios",
                    new { model.Id_EstadoRegistro, model.Id_usuario }, commandType: CommandType.StoredProcedure);

                var respuesta = new RespuestaModel();
                string rutaPlantilla = "";
                string contenidoHtml = "";

                var result = context.QueryFirstOrDefault<UsuarioModel>("VerificarCorreo",
                    new { model.Correo });

                if (nombreEstado == "ELIMINADO")
                {
                    respuesta.Indicador = true;
                    respuesta.Mensaje = "El usuario fue eliminado correctamente.";
                    rutaPlantilla = Path.Combine(Directory.GetCurrentDirectory(), "Templates", "TemplateUsuarioDenegado.html");
                }
                else if (!string.IsNullOrEmpty(nombreEstado))
                {
                    respuesta.Indicador = true;
                    respuesta.Mensaje = "El estado del registro del usuario ha sido actualizado a " + nombreEstado;
                    rutaPlantilla = Path.Combine(Directory.GetCurrentDirectory(), "Templates", "TemplateEstadoAceptado.html");

                    if (nombreEstado == "Aceptado")
                    {
                        string codigo = CreatePassword();
                        string contrasennaEncriptada = Encrypt(codigo);
                        string contrasennaAnterior = string.Empty;

                        var fechaVencimiento = model.password_temp_expiration = DateTime.Now.AddMinutes(
                            double.Parse(_configuration.GetSection("Variables:MinutosVigenciaTemporal").Value!));

                        context.Execute("RecuperarContrasenna",
                            new { result!.Id_usuario, Contrasenna = contrasennaEncriptada, ContrasennaAnterior = contrasennaAnterior, VencimientoContraTemp = fechaVencimiento });

                        contenidoHtml = System.IO.File.ReadAllText(rutaPlantilla);
                        contenidoHtml = contenidoHtml.Replace("@@Codigo", codigo);
                    }
                }
                else
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "No se ha podido actualizar el estado del usuario.";
                }

                if (System.IO.File.Exists(rutaPlantilla))
                {
                    if (string.IsNullOrEmpty(contenidoHtml))
                    {
                        contenidoHtml = System.IO.File.ReadAllText(rutaPlantilla);
                    }

                    contenidoHtml = contenidoHtml
                        .Replace("@@NOMBRE_USUARIO", result!.NombreUsuario)
                        .Replace("@@FECHA_GENERACION", DateTime.Now.ToString("dd/MM/yyyy HH:mm"))
                        .Replace("@@ESTADO_NUEVO", nombreEstado);

                    string mensajeExtra = string.IsNullOrEmpty(mensaje) ? "" : mensaje;
                    contenidoHtml = contenidoHtml.Replace("@@MENSAJE_EXTRA", mensajeExtra);

                    _general.EnviarCorreo(model.Correo!, "Actualización de Acceso", contenidoHtml);
                }

                return Ok(respuesta);
            }
        }





        [HttpGet]
        [Route("ObtenerUsuariosEspera")]
        public IActionResult ObtenerUsuariosEspera()
        {
            try
            {
                long idUsuario = _general.ObtenerUsuarioFromToken(User.Claims);

                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }
                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<UsuarioModel>("ObtenerUsuariosEspera", new { Id_usuario = idUsuario }, commandType: CommandType.StoredProcedure).ToList();
                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }


        }


        [HttpGet]
        [Route("ObtenerEstados")]
        public IActionResult ObtenerEstados()
        {
            try
            {

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<EstadoModel>("ObtenerEstados", commandType: CommandType.StoredProcedure).ToList();

                    var estados = result.Select(estado => new
                    {
                        id = estado.id_estadoRegistro,
                        text = estado.nombre
                    }).ToList();

                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }

        }

        private string CreatePassword()
        {
            int length = 10;
            const string valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();

        }
        private string Encrypt(string texto)
        {
            byte[] iv = new byte[16];
            byte[] array;

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(_configuration.GetSection("Variables:llaveCifrado").Value!);
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
    }
}
