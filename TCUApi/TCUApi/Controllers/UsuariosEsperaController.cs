using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MySqlConnector;
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
            try
            {
                string mensaje = model.mensaje!;

                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }

                using (var context = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    var respuesta = new RespuestaModel();
                    string rutaPlantilla = "";
                    string contenidoHtml = "";

                    var result = context.QueryFirstOrDefault<UsuarioModel>("VerificarCorreo",
                        new { p_Correo = model.Correo });

                    var nombreEstado = context.ExecuteScalar<string>("AccesoUsuarios",
                        new { p_Id_EstadoRegistro = model.Id_EstadoRegistro, p_Id_Usuario = model.Id_usuario }, commandType: CommandType.StoredProcedure);

                    if (result != null)
                    {
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
                                string contrasennaEncriptada = _general.HashSHA256(codigo);
                                string contrasennaAnterior = string.Empty;

                                var fechaVencimiento = model.password_temp_expiration = DateTime.Now.AddMinutes(
                                    double.Parse(_configuration.GetSection("Variables:MinutosVigenciaTemporal").Value!));

                                context.Execute("RecuperarContrasenna",
                                    new
                                    {
                                        p_Id_usuario = result!.Id_usuario,
                                        p_Contrasenna = contrasennaEncriptada,
                                        p_ContrasennaAnterior = contrasennaAnterior,
                                        p_VencimientoContraTemp = fechaVencimiento
                                    });

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
                                .Replace("@@NOMBRE_INGRESO", result!.Username)
                                .Replace("@@ESTADO_NUEVO", nombreEstado);

                            string mensajeExtra = string.IsNullOrEmpty(mensaje) ? "" : mensaje;
                            contenidoHtml = contenidoHtml.Replace("@@MENSAJE_EXTRA", mensajeExtra);

                            _general.EnviarCorreo(model.Correo!, "Actualización de Acceso", contenidoHtml);
                        }

                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "No se ha encontrado el correo en la base de datos.";
                    }

                    return Ok(respuesta);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    mensaje = "Error interno en el servidor.",
                    detalle = ex.Message,
                    stackTrace = ex.StackTrace
                });
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
                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<UsuarioModel>("ObtenerUsuariosEspera", new { p_Id_usuario = idUsuario }, commandType: CommandType.StoredProcedure).ToList();
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


        [HttpGet]
        [Route("ObtenerEstados")]
        public IActionResult ObtenerEstados()
        {
            try
            {

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
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
            catch (MySqlException MySqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = MySqlEx.Message });
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
       
    }
}
