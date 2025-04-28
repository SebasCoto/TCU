using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    //[Authorize]
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
        [Route("AccesoUsuarios")]
        public IActionResult AccesoUsuarios(UsuarioModel model)
        {
            //if (!_general.EsAdministrador(User.Claims))
            //{
            //    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
            //}

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

                        var fechaVencimiento = model.password_temp_expiration = DateTime.Now.AddMinutes(double.Parse(_configuration.GetSection("Variables:MinutosVigenciaTemporal").Value!));
                       
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

                    _general.EnviarCorreo(model.Correo!, "Actualización de Acceso", contenidoHtml);
                }

                return Ok(respuesta);
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

        [HttpGet]
        [Route("ObtenerUsuarios")]
        public IActionResult obtenerUsuarios()
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }
                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<UsuarioModel>("ObtenerUsuarios", new { Id_usuario = 0 }, commandType: CommandType.StoredProcedure).ToList();
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
                long idUsuario = _general.ObtenerUsuarioFromToken(User.Claims);

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    connection.Open();

                    using (var transaction = connection.BeginTransaction())
                    {
                        var result = connection.Execute(
                            "ActualizarContrasenna",
                            new
                            {
                                Id_usuario = idUsuario,
                                Password = encryptedPassword,
                                model.OldPassword,
                                model.ConfirmPassword,
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
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
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

                using (var context = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("ActualizarUsuario", new
                    {
                        Id_usuario = idUsuario,
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

        [HttpGet]
        [Route("ObtenerPerfil")]
        public IActionResult ObtenerPerfil()
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }
                long idUsuario = _general.ObtenerUsuarioFromToken(User.Claims);

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<UsuarioModel>("ObtenerUsuarios", new { Id_usuario = idUsuario }, commandType: CommandType.StoredProcedure).ToList();
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
        #endregion




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

