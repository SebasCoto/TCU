using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
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
    public class UsuarioController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;

        public UsuarioController(IConfiguration configuration, IGeneral general)
        {
            _configuration = configuration;
            _general = general;
        }

        #region -----Usuarios-----

        





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

                using (var context = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("ActualizarUsuario", new
                    {
                        p_Id_Usuario = model.Id_usuario,
                        p_NombreUsuario = model.NombreUsuario,
                        p_Apellidos = model.Apellidos,
                        p_Correo = model.Correo,
                        p_Username = model.Username,
                        p_Id_Rol = model.Id_Rol,
                    });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Usuario actualizado correctamente" : "Error al actualizar el usuario"
                    });
                }
            }
            catch (MySqlException MySqlEx)
            {
                return StatusCode(500, new { Indicador = false, Mensaje = MySqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { Indicador = false, Mensaje = ex.Message });
            }
        }



        [HttpDelete]
        [Route("EliminarUsuario")]
        public IActionResult EliminarUsuario(int id)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar usuarios" });
                }

                using (var context = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("EliminarUsuario", new { p_Id_Usuario = id });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Usuario eliminado correctamente" : "Error al eliminar el usuario"
                    });
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
        [Route("ObtenerUsuarios")]
        public IActionResult obtenerUsuarios()
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
                    var result = connection.Query<UsuarioModel>("ObtenerVoluntarios", new { p_Id_usuario = idUsuario }, commandType: CommandType.StoredProcedure).ToList();
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
        [Route("ObtenerUsuarioById")]
        public IActionResult ObtenerUsuarioById(long id)
        {
            try
            {

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<UsuarioModel>("ObtenerUsuarios", new { p_Id_Usuario = id }, commandType: CommandType.StoredProcedure).ToList();
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

        #endregion


        #region -----Perfil-----

        [HttpPut]
        [Route("ActualizarContrasenna")]
        public IActionResult ActualizarContrasenna(UsuarioModel model)
        {
            try
            {
                if (model == null)
                {
                    return BadRequest(new { Indicador = false, Mensaje = "Datos inválidos" });
                }


                if (model.OldPassword == model.Password)
                {
                    return BadRequest(new { Indicador = false, Mensaje = "La contraseña anterior no puede ser igual a la nueva" });
                }

                if (model.Password != model.ConfirmPassword)
                {
                    return BadRequest(new { Indicador = false, Mensaje = "La contraseña nueva no coincide con la confirmación" });
                }

                string encryptedPassword = _general.Encrypt(model.Password!);
                string encryptedPasswordConfirm = _general.Encrypt(model.ConfirmPassword!);
                string encryptedPasswordOld = _general.Encrypt(model.OldPassword!);
                long idUsuario = _general.ObtenerUsuarioFromToken(User.Claims);

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    connection.Open();

                    using (var transaction = connection.BeginTransaction())
                    {
                        var result = connection.Execute(
                            "ActualizarContrasenna",
                            new
                            {
                                p_Id_usuario = idUsuario,
                                p_Contrasena = encryptedPassword,
                                p_ContrasennaAnterior = encryptedPasswordOld,
                                p_ContrasennaConfirmar = encryptedPasswordConfirm,
                            },
                            transaction,
                            commandType: CommandType.StoredProcedure
                        );

                        if (result > 0)
                        {
                            transaction.Commit();
                            return Ok(new { Indicador = true, Mensaje = "Contraseña actualizada correctamente" });
                        }
                        else
                        {
                            transaction.Rollback();
                            return BadRequest(new { Indicador = false, Mensaje = "Error al actualizar la contraseña" });
                        }
                    }
                }
            }
            catch (MySqlException MySqlEx)
            {
                return StatusCode(500, new { Indicador = false , Mensaje = MySqlEx.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = "Error inesperado", detalle = ex.Message });
            }
        }


        [HttpPut]
        [Route("ActualizarPerfil")]
        public IActionResult ActualizarPerfil(UsuarioModel model)
        {
            try
            {
                long idUsuario = _general.ObtenerUsuarioFromToken(User.Claims);

                using (var context = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("ActualizarUsuario", new
                    {
                        p_Id_Usuario = idUsuario,
                        p_NombreUsuario = model.NombreUsuario,
                        p_Apellidos = model.Apellidos,
                        p_Correo = model.Correo,
                        p_Username = model.Username,
                        p_Id_Rol = model.Id_Rol,
                    });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Usuario actualizado correctamente" : "Error al actualizar el usuario"
                    });
                }
            }
            catch (MySqlException MySqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", Mensaje = MySqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", Mensaje = ex.Message });
            }
        }

        [HttpGet]
        [Route("ObtenerPerfil")]
        public IActionResult ObtenerPerfil()
        {
            try
            {
                
                long idUsuario = _general.ObtenerUsuarioFromToken(User.Claims);

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<UsuarioModel>("ObtenerUsuarios", new { p_Id_Usuario = idUsuario }, commandType: CommandType.StoredProcedure).ToList();
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
        #endregion



        [HttpGet]
        [Route("ObtenerRoles")]
        public IActionResult ObtenerRoles()
        {
            try
            {
               
                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<RolModel>("ObtenerRoles",  commandType: CommandType.StoredProcedure).ToList();

                    var roles = result.Select(rol => new
                    {
                        id = rol.id_rol,
                        text = rol.nombre
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


        


    }
}

