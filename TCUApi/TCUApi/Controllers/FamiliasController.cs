using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
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

                var client = _httpClientFactory.CreateClient();
                string apiUrl = $"https://apis.gometa.org/cedulas/{model.cedula_representante}";

                HttpResponseMessage response = await client.GetAsync(apiUrl);
                if (!response.IsSuccessStatusCode)
                {
                    return BadRequest(new { mensaje = "Error al consultar la API externa" });
                }

                string apiResponse = await response.Content.ReadAsStringAsync();
                var datosCedula = JsonConvert.DeserializeObject<Dictionary<string, object>>(apiResponse);

                if (datosCedula == null || !datosCedula.ContainsKey("nombre"))
                {
                    return BadRequest(new { mensaje = "No se encontraron datos para esta cédula" });
                }

                string nombreRepresentante = datosCedula["nombre"].ToString()!;

                using (var connection = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    await connection.OpenAsync();

                    var result = await connection.ExecuteAsync("RegistrarFamilia", new
                    {
                        model.cedula_representante,
                        Nombre_Representante = nombreRepresentante,
                        model.direccion,
                        model.telefono,
                        model.cantidad_familiares,
                        model.cantidad_ninos,
                        model.Id_Vulnerabilidad
                    }, commandType: CommandType.StoredProcedure);

                    respuesta.Indicador = result > 0;
                    respuesta.Mensaje = respuesta.Indicador ? "Familia registrada correctamente" : "No se pudo registrar la familia";
                }

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
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

                var client = _httpClientFactory.CreateClient();
                string apiUrl = $"https://apis.gometa.org/cedulas/{model.cedula_representante}";

                HttpResponseMessage response = await client.GetAsync(apiUrl);
                if (!response.IsSuccessStatusCode)
                {
                    return BadRequest(new { mensaje = "Error al consultar la API externa" });
                }

                string apiResponse = await response.Content.ReadAsStringAsync();
                var datosCedula = JsonConvert.DeserializeObject<Dictionary<string, object>>(apiResponse);

                if (datosCedula == null || !datosCedula.ContainsKey("nombre"))
                {
                    return BadRequest(new { mensaje = "No se encontraron datos para esta cédula" });
                }

                string nombreRepresentante = datosCedula["nombre"].ToString()!;

                using (var connection = new SqlConnection(_configuration.GetSection("ConnectionStrings:AbrazosDBConnection").Value))
                {
                    var result = connection.Execute("ActualizarFamilia", new
                    {
                        model.Id_Familia,
                        Nombre_Representante = nombreRepresentante,
                        model.cedula_representante,
                        model.direccion,
                        model.telefono,
                        model.cantidad_familiares,
                        model.cantidad_ninos,
                        model.Id_Vulnerabilidad
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
        public IActionResult EliminarFamilia([FromBody] FamiliasModel model)
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para eliminar usuarios" });
                }

                using (var context = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = context.Execute("EliminarFamilia", new { model.Id_Familia });

                    return Ok(new RespuestaModel
                    {
                        Indicador = result > 0,
                        Mensaje = result > 0 ? "Familia eliminada correctamente" : "Error al eliminar la familia"
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
        [Route("ObtenerFamilias")]
        public IActionResult ObtenerFamilias()
        {
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }
                using (var connection = new SqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Query<FamiliasModel>("ObtenerFamilias", new { Id_Familia = 0 }, commandType: CommandType.StoredProcedure).ToList();
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

        #endregion



        
    }
}
