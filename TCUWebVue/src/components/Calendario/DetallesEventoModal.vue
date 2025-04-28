<template>
  <div
    class="modal fade"
    id="eventoDetallesModal"
    tabindex="-1"
    aria-labelledby="eventoDetallesModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content rounded-3 shadow-lg">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title" id="eventoDetallesModalLabel">
            <i class="fas fa-calendar-alt"></i> Detalles del Evento
          </h5>
          <button
            type="button"
            class="btn-close btn-close-white"
            data-bs-dismiss="modal"
            aria-label="Cerrar"
          ></button>
        </div>
        <div class="modal-body">
          <div class="row mb-3">
            <div class="col-sm-4 fw-bold">Título:</div>
            <div class="col-sm-8"><span id="eventoDetallesTitulo" class="fw-bold"></span></div>
          </div>
          <div class="row mb-3">
            <div class="col-sm-4 fw-bold">Descripción:</div>
            <div class="col-sm-8"><span id="eventoDetallesDescripcion"></span></div>
          </div>
          <div class="row mb-3">
            <div class="col-sm-4 fw-bold">Fecha de Inicio:</div>
            <div class="col-sm-8"><span id="eventoDetallesFechaInicio"></span></div>
          </div>
          <div class="row mb-3">
            <div class="col-sm-4 fw-bold">Fecha Final:</div>
            <div class="col-sm-8"><span id="eventoDetallesFechaFinal"></span></div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DetallesEventoModal',
  methods: {
    // Métodos para manejar la lógica del modal de detalles del evento
  },
}
</script>

<style scoped>
/* Estilos específicos para el modal de detalles de evento */
</style>
