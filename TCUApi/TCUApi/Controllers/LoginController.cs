using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using TCUApi.Model;


namespace TCUApi.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public LoginController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        #region iniciarSesion
        [HttpPost]
        [Route("login")]
        public IActionResult IniciarSesion(UsuarioModel model)
        {
            using(var context = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
            {
                var result = context.QueryFirstOrDefault<UsuarioModel>("IniciarSesion",
                    new { model.Username, model.Password }, commandType: CommandType.StoredProcedure);

                var respuesta = new RespuestaModel();

                if(result != null)
                {
                    if(!string.IsNullOrEmpty(result.NombreRol))
                        result.Token = GenerarToken(result.Id_usuario, result.NombreRol!);
                    

                    respuesta.Indicador = true; 
                    respuesta.Datos = result;
                }
                else
                {
                    respuesta.Indicador = false;
                    respuesta.Mensaje = "Usuario o contraseña incorrectos";
                }

                return Ok(respuesta);
            }
        }
        #endregion

        #region RecuperarAccesso
        [HttpPost]
        [Route("RecuperarAccesso")]
        public IActionResult RecuperarAccesso(UsuarioModel model)
        {
            return Ok();
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
    }
}
