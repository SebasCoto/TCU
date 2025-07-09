using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MySqlConnector;
using System.Data;
using TCUApi.Model;
using TCUApi.Servicios;

namespace TCUApi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PresupuestoController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IGeneral _general;
        private readonly IHttpClientFactory _httpClientFactory;

        public PresupuestoController(IConfiguration configuration, IGeneral general, IHttpClientFactory httpClient)
        {
            _configuration = configuration;
            _general = general;
            _httpClientFactory = httpClient;
        }

        #region prespuesto



        [HttpPost]
        [Route("RegistrarPresupuesto")]
        public IActionResult RegistrarPresupuesto( decimal MontoTotal)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new { error = "Datos del modelo no válidos", detalle = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList() });
            }

            if(MontoTotal == 0)
            {
                return BadRequest(new {Indicador= false, Mensaje = "El monto no puede ser 0" });

            }
            try
            {
                if (!_general.EsAdministrador(User.Claims))
                {
                    return Unauthorized(new { mensaje = "No tiene permisos para realizar esta acción" });
                }

                using (var connection = new MySqlConnection(_configuration.GetConnectionString("AbrazosDBConnection")))
                {
                    var result = connection.Execute("CalcularPresupuesto", new { p_MONTO_TOTAL = MontoTotal }, commandType: CommandType.StoredProcedure);
                    return Ok(new RespuestaModel { Indicador = true, Mensaje = "Presupuesto registrado correctamente" });
                }
            }
            catch (MySqlException MySqlEx)
            {
                return StatusCode(500, new { error = "Error en la base de datos", detalle = MySqlEx.Message, codigo = MySqlEx.Number });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = "Error en el servidor", detalle = ex.Message });
            }
        }





        #endregion
    }
}
