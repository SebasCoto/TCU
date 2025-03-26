namespace TCUApi.Model
{
    public class ExpedientesModel
    {
        public long Id_Archivo { get; set; }
        public string? Nombre { get; set; }
        public string? Tipo { get; set; }
        public string? Ruta { get; set; }
        public IFormFile? File { get; set; }
        public string? FechaSubida { get; set; }
    }
}
