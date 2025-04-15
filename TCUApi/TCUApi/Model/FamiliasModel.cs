namespace TCUApi.Model
{
    public class FamiliasModel
    {
        public int Id_Familia { get; set; }
        public string? Nombre_Representante { get; set; }
        public string? cedula_representante { get; set; }
        public string? direccion { get; set; }
        public string? telefono { get; set; }
        public int cantidad_familiares { get; set; }
        public int cantidad_ninos { get; set; }
        public int Id_Vulnerabilidad { get; set; }
        public string? Nombre_Vulnerabilidad { get; set; }
        public decimal presupuesto { get; set; }
    }
}
