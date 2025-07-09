using System.Security.Claims;

namespace TCUApi.Servicios
{
    public interface IGeneral
    {
        long ObtenerUsuarioFromToken(IEnumerable<Claim> claims);
        string ObtenerRolFromToken(IEnumerable<Claim> claims);
        bool EsAdministrador(IEnumerable<Claim> claims);

        void EnviarCorreo(string destino, string asunto, string contenido);
        string HashSHA256(string texto);
    }
}
