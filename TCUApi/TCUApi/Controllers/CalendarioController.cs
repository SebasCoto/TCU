using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class CalendarioController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;
        public CalendarioController(IConfiguration configuration, IGeneral general)
        {
            _configuration = configuration;
            _general = general;
        }


        [HttpPost]
        [Route("AgregarEvento")]
        public IActionResult AgregarEvento(EventosModel model)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para crear un evento" });
                }

                RespuestaModel respuesta = new RespuestaModel();

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("RegistrarEvento", new
                    {
                        model.Nombre_Evento,
                        model.Descripcion,
                        model.Fecha_Inicio,
                        model.Fecha_Final,
                        model.Color,
                        model.Invitados,
                    });

                    if (result > 0)
                    {
                        if (!string.IsNullOrEmpty(model.Invitados))
                        {

                            string[] correos = model.Invitados.Split(',');

                            foreach (string correo in correos)
                            {
                                string ruta = Path.Combine(Directory.GetCurrentDirectory(), "Templates", "TemplateEventoCreado.html");
                                string contenidoHtml = System.IO.File.ReadAllText(ruta);

                                contenidoHtml = contenidoHtml
                                    .Replace("@@NOMBRE_EVENTO", model.Nombre_Evento)
                                    .Replace("@@FechaInicio", model.Fecha_Inicio.ToString("dd/MM/yyyy HH:mm"));

                                _general.EnviarCorreo(correo, "Evento creado", contenidoHtml);
                            }

                        }
                        respuesta.Indicador = true;
                        respuesta.Mensaje = "Evento registrado correctamente";
                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Error al registrar el evento";
                    }

                    return Ok(respuesta);
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
        [Route("MostrarEventos")]
        public IActionResult MostrarEventos()
        {
            RespuestaModel respuesta = new RespuestaModel();
            List<object> eventos = new List<object>();

            try
            {
                var idUsuarioLogueado = _general.ObtenerUsuarioFromToken(User.Claims);
                var rolLogueado = _general.ObtenerRolFromToken(User.Claims);

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var correoLogueado = connection.Query<string>(
                        "ObtenerCorreoById",
                        new { Id_Usuario = idUsuarioLogueado },
                        commandType: CommandType.StoredProcedure
                    ).FirstOrDefault()?.Trim();

                    var datos = connection.Query<EventosModel>(
                        "MostrarEventos", new { Id_Evento = 0 },
                        commandType: CommandType.StoredProcedure
                    ).ToList();

                    foreach (var dato in datos)
                    {
                        if (rolLogueado == "Administrador")
                        {
                            eventos.Add(new
                            {
                                id = dato.Id_Evento,
                                title = dato.Nombre_Evento,
                                start = dato.Fecha_Inicio.ToString("yyyy-MM-dd"),
                                end = dato.Fecha_Final.ToString("yyyy-MM-dd"),
                                description = dato.Descripcion,
                                color = dato.Color
                            });
                        }
                        else if (rolLogueado == "Voluntario")
                        {
                            if (!string.IsNullOrEmpty(dato.Invitados))
                            {
                                var listaInvitados = dato.Invitados.Split(',').Select(c => c.Trim());
                                if (listaInvitados.Contains(correoLogueado))
                                {
                                    eventos.Add(new
                                    {
                                        id = dato.Id_Evento,
                                        title = dato.Nombre_Evento,
                                        start = dato.Fecha_Inicio.ToString("yyyy-MM-dd"),
                                        end = dato.Fecha_Final.ToString("yyyy-MM-dd"),
                                        description = dato.Descripcion,
                                        color = dato.Color
                                    });
                                }
                            }
                        }
                    }

                    respuesta.Indicador = true;
                    respuesta.Mensaje = "Eventos cargados correctamente";
                    respuesta.Datos = eventos;
                }
            }
            catch (Exception ex)
            {
                respuesta.Indicador = false;
                respuesta.Mensaje = $"Error al cargar eventos: {ex.Message}";
                respuesta.Datos = null;
            }

            return Ok(respuesta);
        }


        [HttpDelete]
        [Route("EliminarEvento")]
        public IActionResult EliminarEvento(int id)
        {
            RespuestaModel respuesta = new RespuestaModel();
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar un evento" });
                }
                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("EliminarEvento", new { Id_Evento = id }, commandType: CommandType.StoredProcedure);
                    if (result > 0)
                    {
                        respuesta.Indicador = true;
                        respuesta.Mensaje = "Evento eliminado correctamente";
                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Error al eliminar el evento";
                    }
                    return Ok(respuesta);
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


        [HttpPut]
        [Route("EditarEvento")]
        public IActionResult EditarEvento(EventosModel model)
        {
            


            try
            {
                if (model == null || model.Id_Evento <= 0)
                {
                    return BadRequest(new { success = false, message = "Datos inválidos." });
                }

                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar un evento" });
                }
                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    RespuestaModel respuesta = new RespuestaModel();
                    var result = connection.Execute("ActualizarEvento", new { model.Id_Evento,model.Nombre_Evento,model.Descripcion, model.Fecha_Inicio, model.Fecha_Final }, commandType: CommandType.StoredProcedure);
                    if (result > 0)
                    {
                        respuesta.Indicador = true;
                        respuesta.Mensaje = "Evento editado correctamente";
                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Error al editar el evento";
                    }
                    return Ok(respuesta);
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
        [Route("ObtenerCorreosSeleccionados")]
        public IActionResult ObtenerCorreosSeleccionados([FromQuery] string q = null!) // Parámetro opcional
        {
            var respuesta = new { results = new List<object>() };

            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para crear un evento" });
                }
                var idUsuarioLogueado = _general.ObtenerUsuarioFromToken(User.Claims);

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var correoLogueado = connection.Query<string>(
                        "ObtenerCorreoById",
                        new { Id_Usuario = idUsuarioLogueado },
                        commandType: CommandType.StoredProcedure
                    ).FirstOrDefault()?.Trim();

                    if (string.IsNullOrEmpty(correoLogueado))
                        return Ok(respuesta);

                    var empleados = connection.Query(
                        "ObtenerCorreosSeleccionados",
                        new
                        {
                            CorreoLogueado = correoLogueado,
                            Filtro = q // Puede ser null o un valor
                        },
                        commandType: CommandType.StoredProcedure
                    ).ToList();

                    var resultados = empleados.Select(emp => new
                    {
                        id = emp.correo,
                        text = emp.nombre
                    }).ToList();

                    return Ok(new { results = resultados });
                }
            }
            catch (Exception ex)
            {
                // Loguear el error para depuración
                Console.WriteLine($"Error en ObtenerCorreosSeleccionados: {ex.Message}");
                return Ok(respuesta);
            }
        }

        [HttpGet]
        [Route("GetEventById")]
        public IActionResult GetEventById(long id)
        {
            RespuestaModel respuesta = new RespuestaModel();

            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para obtener un evento" });
                }

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var evento = connection.Query<EventosModel>(
                        "MostrarEventos",
                        new { Id_Evento = id },
                        commandType: CommandType.StoredProcedure
                    ).FirstOrDefault();

                    if (evento != null)
                    {
                        respuesta.Indicador = true;
                        respuesta.Mensaje = "Evento obtenido correctamente";
                        respuesta.Datos = evento;
                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Evento no encontrado";
                        respuesta.Datos = null;
                    }
                }
            }
            catch (Exception ex)
            {
                respuesta.Indicador = false;
                respuesta.Mensaje = $"Error al obtener el evento: {ex.Message}";
                respuesta.Datos = null;
            }

            return Ok(respuesta);
        }

    }
}
