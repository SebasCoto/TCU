using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;


namespace TCUApi.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;
        public LoginController(IConfiguration configuration,IGeneral general)
        {
            _configuration = configuration;
            _general = general;
        }

        #region iniciarSesion
        [HttpPost]
        [Route("login")]
        public IActionResult IniciarSesion(UsuarioModel model)
        {
            using (var context = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                var result = context.QueryFirstOrDefault<UsuarioModel>("IniciarSesion",
                    new { model.Username, model.Password }, commandType: CommandType.StoredProcedure);

                var respuesta = new RespuestaModel();

                if (result == null)
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "Usuario o contraseña incorrectos";
                    return Ok(respuesta);
                }

                if (result.Id_EstadoRegistro == 3)
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "Usted está en lista de espera, no puede acceder al sistema";
                    return Ok(respuesta);
                }

                // Usuario válido
                if (!string.IsNullOrEmpty(result.NombreRol))
                    result.Token = GenerarToken(result.Id_usuario, result.NombreRol);

                respuesta.Indicador = true;
                respuesta.Datos = result;
                respuesta.Mensaje = "Se ha iniciado sesión con éxito";

                return Ok(respuesta);
            }
        }

        #endregion



        #region Registrarse
        [HttpPost]
        [Route("RegistrarUsuario")]
        public IActionResult RegistrarUsuario(UsuarioModel model)
        {
            try
            {

                RespuestaModel respuesta = new RespuestaModel();



                model.Password = CreatePassword();
                var username = CreateUsername(model.NombreUsuario!, model.Apellidos!);


                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("RegistrarUsuario", new
                    {
                        model.NombreUsuario,
                        model.Cedula,
                        model.Apellidos,
                        model.Correo,
                        username,
                        model.Password,
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

        #endregion



        #region RecuperarAccesso
        [HttpPost]
        [Route("RecuperarAccesso")]
        public IActionResult RecuperarAccesso(UsuarioModel model)
        {
            using (var context = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                var result = context.QueryFirstOrDefault<UsuarioModel>("VerificarCorreo",
                    new { model.Correo }, commandType: CommandType.StoredProcedure);

                var respuesta = new RespuestaModel();
                if (result != null)
                {
                    var Codigo = CreatePassword();
                    var Contrasenna = _general.Encrypt(Codigo);
                    var ContrasennaAnterior = string.Empty;
                    

                    context.Execute("ActualizarContrasenna", new { result.Id_usuario, Contrasenna, ContrasennaAnterior });

                    string Contenido = "Hola " + result.NombreUsuario + ". Se ha generado el siguiente código de seguridad: " + Codigo;
                    EnviarCorreo(result.Correo!, "Actualización de Acceso", Contenido);

                    respuesta.Indicador = true;
                    respuesta.Datos = result;
                }
                else
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "Correo no registrado";
                }
                return Ok(respuesta);
            }
        }

        #endregion


        #region token
        private string GenerarToken(long id,string rol)
        {
            string SecretKeyt = _configuration.GetSection("Variables:SecretKey").Value!;

            List<Claim> claims = new List<Claim>();
            claims.Add(new Claim("Id", id.ToString()));
            claims.Add(new Claim("rol", rol.ToString()));

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKeyt));
            var cred = new SigningCredentials(key, SecurityAlgorithms.HmacSha256Signature);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: cred);

            return new JwtSecurityTokenHandler().WriteToken(token); 
        }

        #endregion


        #region General

        private string Decrypt(string texto)
        {
            byte[] iv = new byte[16];
            byte[] buffer = Convert.FromBase64String(texto);

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(_configuration.GetSection("Variables:llaveCifrado").Value!);
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

        private void EnviarCorreo(string destino, string asunto, string contenido)
        {
            string cuenta = _configuration.GetSection("Variables:Correo").Value!;
            string contrasenna = _configuration.GetSection("Variables:ClaveEmail").Value!;

            MailMessage message = new MailMessage();
            message.From = new MailAddress(cuenta);
            message.To.Add(new MailAddress(destino));
            message.Subject = asunto;
            message.Body = contenido;
            message.Priority = MailPriority.Normal;
            message.IsBodyHtml = true;

            SmtpClient client = new SmtpClient("smtp.office365.com", 587);
            client.Credentials = new System.Net.NetworkCredential(cuenta, contrasenna);
            client.EnableSsl = true;

            if (!string.IsNullOrEmpty(contrasenna))
            {
                client.Send(message);
            }
        }

        #endregion
    }
}
