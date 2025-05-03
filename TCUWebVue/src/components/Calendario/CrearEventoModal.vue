<template>
  <div
    v-if="modalVisible"
    class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center z-50 transition-opacity duration-300"
  >
    <div
      class="bg-white rounded-xl shadow-lg w-full max-w-sm sm:max-w-md md:max-w-3xl p-6 max-h-[90vh] overflow-auto transform transition-all"
    >
      <div class="modal-header flex justify-between items-center pb-6 border-b">
        <h5 class="text-2xl font-semibold text-gray-800" id="crearEventoModalLabel">
          Crear Nuevo Evento
        </h5>
        <button
          type="button"
          class="text-gray-500 hover:text-gray-700 focus:outline-none"
          @click="cerrarModal"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>
      <div class="modal-body w-full">
        <form @submit.prevent="guardarEvento" class="space-y-4">
          <div>
            <label for="correo-multiselect">Selecciona correos:</label>
            <multiselect
              id="correo-multiselect"
              v-model="selectedCorreos"
              :options="correos"
              :multiple="true"
              :searchable="true"
              :loading="loading"
              :clear-on-select="false"
              :close-on-select="false"
              placeholder="Buscar correos"
              label="text"
              track-by="id"
              @search-change="buscarCorreos"
            >
              <template #noResult>
                <span class="text-gray-500">No se encontraron voluntarios.</span>
              </template>
            </multiselect>
          </div>

          <div class="form-group mb-4">
            <label for="eventoTitulo" class="block text-sm font-medium text-gray-700"
              >Título del Evento:</label
            >
            <input
              type="text"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoTitulo"
              v-model="evento.titulo"
              placeholder="Ingrese el título del evento"
              required
            />
          </div>
          <div class="form-group mb-4">
            <label for="eventoDescripcion" class="block text-sm font-medium text-gray-700"
              >Descripción:</label
            >
            <textarea
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoDescripcion"
              v-model="evento.descripcion"
              rows="3"
            ></textarea>
          </div>
          <div class="form-group mb-4">
            <label for="eventoFechaInicio" class="block text-sm font-medium text-gray-700"
              >Fecha de inicio:</label
            >
            <input
              type="date"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoFechaInicio"
              v-model="evento.fechaInicio"
              required
            />
          </div>
          <div class="form-group mb-4">
            <label for="eventoFechaFinal" class="block text-sm font-medium text-gray-700"
              >Fecha Final:</label
            >
            <input
              type="date"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoFechaFinal"
              v-model="evento.fechaFinal"
              required
            />
          </div>
          <div class="form-group mb-4">
            <label for="color" class="block text-sm font-medium text-gray-700">Color:</label>
            <input
              type="color"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="color"
              v-model="evento.color"
              required
            />
          </div>
        </form>
      </div>
      <div class="modal-footer flex justify-end space-x-4 p-4 border-t">
        <button
          type="button"
          class="btn btn-primary bg-blue-600 text-white py-2 px-6 rounded-lg hover:bg-blue-700 transition duration-200"
          @click="guardarEvento"
        >
          Guardar Evento
        </button>
        <button
          type="button"
          class="btn btn-secondary bg-gray-300 text-black py-2 px-6 rounded-lg hover:bg-gray-400 transition duration-200"
          @click="cerrarModal"
        >
          Cerrar
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import '@/assets/Js/modalCrearFunciones.js'
import modalCrearFunciones from '@/assets/Js/modalCrearFunciones.js'
import Multiselect from 'vue-multiselect'

export default {
  components: {
    Multiselect,
  },
  props: {
    modalVisible: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    // Usa las funciones y variables del archivo JS
    const {
      correos,
      selectedCorreos,
      loading,
      buscarCorreos,
      guardarEvento,
      cerrarModal,
      mensaje,
      errorMsg,
      evento,
    } = modalCrearFunciones.setup(props, { emit })

    return {
      correos,
      selectedCorreos,
      loading,
      buscarCorreos,
      guardarEvento,
      cerrarModal,
      mensaje,
      errorMsg,
      evento,
    }
  },
}
</script>

<style>
@import 'vue-multiselect/dist/vue-multiselect.css';
</style>
