using System.Security.Claims;

namespace TCUApi.Servicios
{
    public interface IGeneral
    {
        long ObtenerUsuarioFromToken(IEnumerable<Claim> claims);
        string ObtenerRolFromToken(IEnumerable<Claim> claims);
        bool EsAdministrador(IEnumerable<Claim> claims);

        string Encrypt(string texto);
    }
}
