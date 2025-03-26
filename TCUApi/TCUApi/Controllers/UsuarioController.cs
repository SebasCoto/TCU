using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;

        public UsuarioController(IConfiguration configuration, IGeneral general)
        {
            _configuration = configuration;
            _general = general;
        }

        [HttpPost]
        [Route("RegistrarUsuario")]
        public IActionResult RegistrarUsuario(UsuarioModel model)
        {
            try
            {
                
                RespuestaModel respuesta = new RespuestaModel();

               
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }

                
                model.Password = CreatePassword();
                var username = CreateUsername(model.NombreUsuario!, model.Apellidos!);

              
                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("RegistrarUsuario", new
                    {
                        model.NombreUsuario,
                        model.Apellidos,
                        model.Correo,
                        username,
                        model.Password,
                        model.Id_Rol
                    });

                    
                    respuesta.Indicador = result > 0;
                    respuesta.Mensaje = result > 0 ? "Usuario registrado correctamente" : "Error al registrar el usuario";
                }

                return Ok(respuesta);
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
        [Route("ActualizarUsuario")]
        public IActionResult ActualizarUsuario(UsuarioModel model)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para actualizar usuarios" });
                }

                using (var context = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("ActualizarUsuario", new
                    {
                        model.Id_usuario,
                        model.NombreUsuario,
                        model.Apellidos,
                        model.Correo,
                        model.Username,
                        model.Id_Rol,
                    });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Usuario actualizado correctamente" : "Error al actualizar el usuario"
                    });
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



        [HttpDelete]
        [Route("EliminarUsuario")]
        public IActionResult EliminarUsuario([FromBody] UsuarioModel model)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar usuarios" });
                }

                using (var context = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("EliminarUsuario", new { model.Id_usuario });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Usuario eliminado correctamente" : "Error al eliminar el usuario"
                    });
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

        private string CreateUsername(string nombre, string apellido)
        {
            if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(apellido))
            {
                return string.Empty;
            }

            char incialNombre = char.ToLower(nombre[0]);
            string primerApellido = apellido.Split(" ")[0].ToLower();

            return $"{incialNombre}{primerApellido}";
        }


    }
}

