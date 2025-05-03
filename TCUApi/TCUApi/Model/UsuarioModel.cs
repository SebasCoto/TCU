namespace TCUApi.Model
{
    public class UsuarioModel
    {

        public long Id_usuario { get; set; }
        public long Cedula { get; set; }
        public string? NombreUsuario { get; set; }
        public string? Apellidos { get; set; }
        public string? Correo { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
        public string? OldPassword { get; set; }
        public string? ConfirmPassword { get; set; }
        public string? Token { get; set; }
        public int Id_Rol { get; set; }
        public string? NombreRol { get; set; }
        public long Id_EstadoRegistro { get; set; }
        public string?  NombreEstadoRegistro { get; set; }
        public DateTime fecha_registro { get; set; }
        public bool password_temp_status { get; set; }
        public DateTime password_temp_expiration { get; set; }

        public string? imgUsuario { get; set; }
        public string? mensaje { get; set; }
    }
}
