using System.Security.Claims;

namespace TCUApi.Servicios
{
    public class General : IGeneral
    {
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
    }
}
