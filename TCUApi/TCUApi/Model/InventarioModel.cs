namespace TCUApi.Model
{
    public class InventarioModel
    {
        public int Id_Inventario { get; set; }

        public string? NombreProducto{ get; set; }
        public int Id_Categoria{ get; set; }
        public string? NombreCategoria { get; set; }
        public int stock{ get; set; }
    }
}
