using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    //[Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class InventarioController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;
        public InventarioController(IConfiguration configuration,IGeneral general)
        {
            _general = general;
            _configuration = configuration;
        }


        [HttpPost]
        [Route("RegistrarProducto")]
        public IActionResult RegistrarProducto(InventarioModel model)
        {
            try
            {
               

                RespuestaModel respuesta = new RespuestaModel();

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("RegistrarProducto", new
                    {
                        model.NombreProducto,
                        model.Id_Categoria,
                        model.stock
                    });


                    respuesta.Indicador = result > 0;
                    respuesta.Mensaje = result > 0 ? "Producto registrado correctamente" : "Error al registrar el Producto";
                }

                return Ok(respuesta);
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }
        }


        [HttpGet]
        [Route("ObtenerCategorias")]
        public IActionResult ObtenerCategorias()
        {
            try
            {

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<CategoriaModel>("ObtenerCategorias", commandType: CommandType.StoredProcedure).ToList();

                    var categorias = result.Select(categoria => new
                    {
                        id = categoria.id_categoria,
                        text = categoria.nombre
                    }).ToList();

                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }

        }

        [HttpPut]
        [Route("ActualizarProducto")]
        public IActionResult ActualizarProducto(InventarioModel model)
        {
            try
            {
                

                using (var context = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("ActualizarProducto", new
                    {
                        model.Id_Inventario,
                        model.NombreProducto,
                        model.Id_Categoria,
                        model.stock
                    });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Producto actualizado correctamente" : "Error al actualizar el Producto"
                    });
                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { Indicador = false, Mensaje = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { Indicador = false, Mensaje = ex.Message });
            }
        }


        [HttpDelete]
        [Route("EliminarProducto")]
        public IActionResult EliminarProducto(int id)
        {
            try
            {
                

                using (var context = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute(
                        "EliminarProducto",
                        new { Id_Inventario = id },
                        commandType: CommandType.StoredProcedure
                    );

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Producto eliminado correctamente" : "Error al eliminar el producto"
                    });
                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }
        }


        [HttpGet]
        [Route("ObtenerProductos")]
        public IActionResult ObtenerProductos()
        {
            try
            {
                

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<InventarioModel>("ObtenerProductos", new { Id_Inventario = 0 }, commandType: CommandType.StoredProcedure).ToList();
                    if (!result.Any())
                    {
                        return Ok(new RespuestaModel
                        {
                            Indicador = false,
                            Mensaje = "No se encontraron productos"
                        });
                    }

                    return Ok(new RespuestaModel { Indicador = true, Datos = result });


                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }


        }


        [HttpGet]
        [Route("ObtenerProductoById")]
        public IActionResult ObtenerProductoById(int id)
        {
            try
            {
                

                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<InventarioModel>("ObtenerProductos", new { Id_Inventario = id }, commandType: CommandType.StoredProcedure).ToList();
                    if (!result.Any())
                    {
                        return Ok(new RespuestaModel
                        {
                            Indicador = false,
                            Mensaje = "No se encontraron productos"
                        });
                    }

                    return Ok(new RespuestaModel { Indicador = true, Datos = result });


                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }


        }
    }
}
