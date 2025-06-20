using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class FamiliasController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;
        private readonly IHttpClientFactory _httpClientFactory;

        public FamiliasController(IConfiguration configuration, IGeneral general, IHttpClientFactory httpClient)
        {
            _configuration = configuration;
            _general = general;
            _httpClientFactory = httpClient;
        }
        #region Familias
        [HttpPost]
        [Route("RegistrarFamilia")]
        public async Task<IActionResult> RegistrarFamilia([FromBody] FamiliasModel model)
        {
            try
            {
                RespuestaModel respuesta = new RespuestaModel();

               

                using (var connection = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    await connection.OpenAsync();

                    var isVoluntario = await connection.QueryAsync("VerificarIsVoluntario",new { p_Cedula =model.cedula_representante },commandType: CommandType.StoredProcedure);

                    if(isVoluntario.Any())
                    {
                        return BadRequest(new { Indicador =false , Mensaje = "El usuario es un voluntario por lo que no se puede registrara como representante" });

                    }


                    var result = await connection.ExecuteAsync("RegistrarFamilia", new
                    {
                        p_Nombre_Representante = model.Nombre_Representante,
                        p_Cedula_Representante = model.cedula_representante,
                        p_Direccion = model.direccion,
                        p_Telefono = model.telefono,
                        p_Cantidad_Familiares = model.cantidad_familiares,
                        p_Cantidad_Ninos = model.cantidad_ninos,
                        p_Id_Vulnerabilidad = model.Id_Vulnerabilidad
                    }, commandType: CommandType.StoredProcedure);

                    respuesta.Indicador = result > 0;
                    respuesta.Mensaje = respuesta.Indicador ? "Familia registrada correctamente" : "No se pudo registrar la familia";
                }

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return BadRequest(new { Mensaje = ex.Message });
            }
        }


        [HttpPut]
        [Route("ActualizarFamilia")]
        public async Task<IActionResult> ActualizarFamilia([FromBody] FamiliasModel model)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar usuarios" });
                }
                RespuestaModel respuesta = new RespuestaModel();

               

                using (var connection = new MySqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    connection.Open();

                    var result = connection.Execute("ActualizarFamilia", new
                    {
                        p_Id_Familia = model.Id_Familia,
                        p_Nombre_Representante = model.cedula_representante,
                        p_Cedula_Representante = model.Nombre_Representante,
                        p_Direccion = model.direccion,
                        p_Telefono = model.telefono,
                        p_Cantidad_Familiares = model.cantidad_familiares,
                        p_Cantidad_Ninos = model.cantidad_ninos,
                        p_Id_Vulnerabilidad = model.Id_Vulnerabilidad
                    }, commandType: CommandType.StoredProcedure);

                    respuesta.Indicador = result > 0;
                    respuesta.Mensaje = respuesta.Indicador ? "Familia actualizada correctamente" : "No se pudo actualizar la familia";


                }

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }

        }


        [HttpDelete]
        [Route("EliminarFamilia")]
        public IActionResult EliminarFamilia(int id)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar usuarios" });
                }

                using (var context = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    context.Open();

                    var result = context.Execute("EliminarFamilia", new { p_Id_Familia = id });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Familia eliminada correctamente" : "Error al eliminar la familia"
                    });
                }
            }
            catch (MySqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }
        }

        [HttpGet]
        [Route("ObtenerFamilias")]
        public IActionResult ObtenerFamilias()
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }
                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    connection.Open();  
                    var result = connection.Query<FamiliasModel>("ObtenerFamilias", new { p_Id_Familia = 0 }, commandType: CommandType.StoredProcedure).ToList();
                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (MySqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }


        }

        [HttpGet]
        [Route("ObtenerFamiliaById")]
        public IActionResult ObtenerUsuarioById(long id)
        {
            try
            {

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    connection.Open();
                    var result = connection.Query<FamiliasModel>("ObtenerFamilias", new { p_Id_Familia = id }, commandType: CommandType.StoredProcedure).ToList();
                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (MySqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }


        }

        [HttpGet]
        [Route("ObtenerVulnerabilidad")]
        public IActionResult ObtenerVulnerabilidad()
        {
            try
            {

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    connection.Open();
                    var result = connection.Query<VulnerabilidadModel>("ObtenerVulnerabilidad", commandType: CommandType.StoredProcedure).ToList();

                    var vulnerabilidades = result.Select(vulnerabilidad => new
                    {
                        id = vulnerabilidad.id_vulnerabilidad,
                        text = vulnerabilidad.nombre
                    }).ToList();

                    return Ok(new RespuestaModel { Indicador = true, Datos = result });
                }
            }
            catch (MySqlException sqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }

        }

        #endregion




    }
}
