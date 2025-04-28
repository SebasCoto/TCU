using Microsoft.Extensions.Configuration;
using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace TCUApi.Servicios
{
    public class General : IGeneral
    {
        private readonly IConfiguration _configuration;
        public General(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public long ObtenerUsuarioFromToken(IEnumerable<Claim> claims)
        {
            var idUsuario = claims.FirstOrDefault(x => x.Type == "Id")?.Value;
            return long.TryParse(idUsuario, out var id) ? id : 0; 
        }

        public string ObtenerRolFromToken(IEnumerable<Claim> claims)
        {
            return claims.FirstOrDefault(x => x.Type == "rol")?.Value ?? "Invitado"; 
        }

        public bool EsAdministrador(IEnumerable<Claim> claims)
        {
            return ObtenerRolFromToken(claims) == "Administrador"; 
        }

        public string Encrypt(string texto)
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


        public void EnviarCorreo(string destino, string asunto, string contenido)
        {
            string cuenta = _configuration["Variables:Correo"]!;
            string contrasenna = _configuration["Variables:ClaveEmail"]!;

            using (MailMessage mensaje = new MailMessage())
            {
                mensaje.From = new MailAddress(cuenta);
                mensaje.To.Add(destino);
                mensaje.Subject = asunto;
                mensaje.Body = contenido;
                mensaje.IsBodyHtml = true;
                mensaje.Priority = MailPriority.Normal;

                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.Credentials = new NetworkCredential(cuenta, contrasenna);
                    smtp.EnableSsl = true;

                    if (!string.IsNullOrEmpty(contrasenna))
                    {
                        try
                        {
                            smtp.Send(mensaje);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Error al enviar el correo: " + ex.Message);
                            throw;
                        }
                    }
                }
            }
        }

    }
}
