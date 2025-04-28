namespace TCUApi.Model
{
    public class EventosModel
    {
        public long Id_Evento { get; set; }
        public string? Nombre_Evento { get; set; }
        public string? Descripcion { get; set; }
        public DateTime Fecha_Inicio { get; set; }
        public DateTime Fecha_Final{ get; set; }
        public string? Color{ get; set; }
        public string? Invitados{ get; set; }
    }
}
