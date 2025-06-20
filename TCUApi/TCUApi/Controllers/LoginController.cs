using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;
using MySql.Data.MySqlClient;



namespace TCUApi.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;
        private readonly IHttpClientFactory _httpClientFactory;
        public LoginController(IConfiguration configuration, IGeneral general, IHttpClientFactory httpClientFactory)
        {
            _configuration = configuration;
            _general = general;
            _httpClientFactory = httpClientFactory;
        }

        #region iniciarSesion
        [HttpPost]
        [Route("login")]
        public IActionResult IniciarSesion(UsuarioModel model)
        {
            using (var context = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                context.Open();
                var contraEncriptada = Encrypt(model.Password!);
                var result = context.QueryFirstOrDefault<UsuarioModel>("IniciarSesion",
                    new {   model.Username, p_password = contraEncriptada }, commandType: CommandType.StoredProcedure);

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

                if(result.password_temp_expiration > DateTime.Now)
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "El tiempo de la contraseña temporal expiro";
                    return Ok(respuesta);
                }

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
                var passwordEncrypted = Encrypt(model.Password);
                var username = CreateUsername(model.NombreUsuario!, model.Apellidos!);

                

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("RegistrarUsuario", new
                    {
                        p_NombreUsuario= model.NombreUsuario,
                        p_Cedula = model.Cedula,
                        p_Apellidos = model.Apellidos,
                        p_Correo =  model.Correo,
                        p_Username = username,
                        p_Password  = passwordEncrypted,
                        p_Telefono = model.Telefono
                    });


                    if (result > 0)
                    {
                       
                        var fechaVencimiento = model.password_temp_expiration = DateTime.Now.AddMinutes(double.Parse(_configuration.GetSection("Variables:MinutosVigenciaTemporal").Value!));

                        var datos = connection.QueryFirstOrDefault<UsuarioModel>("VerificarCorreo",
                            new { p_Correo = model.Correo });


                        string ruta = Path.Combine(Directory.GetCurrentDirectory(), "Templates", "CorreoCodigoAcceso.html");
                        string contenidoHtml = System.IO.File.ReadAllText(ruta);

                        contenidoHtml = contenidoHtml
                            .Replace("@@NOMBRE_USUARIO", datos!.NombreUsuario)
                            .Replace("@@FECHA_GENERACION", DateTime.Now.ToString("dd/MM/yyyy HH:mm"));

                        _general.EnviarCorreo(model.Correo!, "Usuario en espera", contenidoHtml);

                        respuesta.Indicador = true;
                        respuesta.Mensaje = "Correo enviado correctamente";
                        respuesta.Datos = result;
                    }
                    else
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Su información no se ha validado correctamente";
                    }
                }

                return Ok(respuesta);
            }
            catch (MySqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", Mensaje = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", Mensaje = ex.Message });
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
        [HttpPut]
        [Route("RecuperarContrasenna")]
        public IActionResult RecuperarContrasenna(UsuarioModel model)
        {
            var respuesta = new RespuestaModel();

            using (var context = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                var result = context.QueryFirstOrDefault<UsuarioModel>("VerificarCorreo",
                    new { p_Correo = model.Correo });

                if (result != null)
                {

                    if(result.NombreEstadoRegistro != "Aceptado")
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Usted todavia no tiene acceso al sistema";
                        return Ok(respuesta);
                    }
                    if (result.password_temp_status)
                    {
                        respuesta.Indicador = false;
                        respuesta.Mensaje = "Ya se ha enviado un correo para recuperar la contraseña, por favor revise su bandeja de entrada";
                        return Ok(respuesta);
                    }

                    string codigo = CreatePassword();
                    string contrasennaEncriptada = Encrypt(codigo);
                    string contrasennaAnterior = string.Empty;




                    var fechaVencimiento = model.password_temp_expiration = DateTime.Now.AddMinutes(double.Parse(_configuration.GetSection("Variables:MinutosVigenciaTemporal").Value!));

                    context.Execute("RecuperarContrasenna",
                        new { p_Id_usuario = result.Id_usuario, p_Contrasenna = contrasennaEncriptada, p_ContrasennaAnterior = contrasennaAnterior, p_VencimientoContraTemp = fechaVencimiento });


                    string ruta = Path.Combine(Directory.GetCurrentDirectory(), "Templates", "TemplateCorreoRecuperarContrasena.html");
                    string contenidoHtml = System.IO.File.ReadAllText(ruta);

                    contenidoHtml = contenidoHtml
                        .Replace("@@NOMBRE_USUARIO", result.NombreUsuario)
                        .Replace("@@CODIGO_SEGURIDAD", codigo)
                        .Replace("@@FECHA_GENERACION", DateTime.Now.ToString("dd/MM/yyyy HH:mm"));

                    _general.EnviarCorreo(result.Correo!, "Actualización de Acceso", contenidoHtml);

                    respuesta.Indicador = true;
                    respuesta.Mensaje = "Correo enviado correctamente";
                    respuesta.Datos = result;
                }
                else
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "Su información no se ha validado correctamente";
                }

                return Ok(respuesta);
            }
        }

        #endregion


        #region token
        private string GenerarToken(long id, string rol)
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

        #endregion
    }
}
