<template>
  <div
    class="modal fade"
    id="editarEventoModal"
    tabindex="-1"
    aria-labelledby="editarEventoModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="editarEventoModalLabel">Editar Evento</h5>
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Cerrar"
          ></button>
        </div>
        <div class="modal-body">
          <form id="formEditarEvento">
            <input type="hidden" id="editarEventoId" />
            <div class="mb-3">
              <label for="editarEventoTitulo" class="form-label">Título del Evento</label>
              <input type="text" class="form-control" id="editarEventoTitulo" required />
            </div>
            <div class="mb-3">
              <label for="editarEventoDescripcion" class="form-label">Descripción</label>
              <textarea class="form-control" id="editarEventoDescripcion"></textarea>
            </div>
            <div class="mb-3">
              <label for="editarEventoFechaInicio" class="form-label">Fecha de Inicio</label>
              <input type="date" class="form-control" id="editarEventoFechaInicio" required />
            </div>
            <div class="mb-3">
              <label for="editarEventoFechaFinal" class="form-label">Fecha de Finalización</label>
              <input type="date" class="form-control" id="editarEventoFechaFinal" />
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
          <button type="button" class="btn btn-danger" id="eliminarEvento">Eliminar</button>
          <button type="button" class="btn btn-primary" id="editarEvento">Editar Evento</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'EditarEventoModal',
  methods: {
    // Métodos para manejar la lógica del modal de edición de evento
  },
}
</script>

<style scoped>
/* Estilos específicos para el modal de editar evento */
</style>
