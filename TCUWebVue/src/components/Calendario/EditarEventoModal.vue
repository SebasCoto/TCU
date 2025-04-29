<template>
  <div
    v-if="modalVisible"
    class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center z-50 transition-opacity duration-300"
  >
    <div
      class="bg-white rounded-xl shadow-lg w-full max-w-sm sm:max-w-md md:max-w-3xl p-6 max-h-[90vh] overflow-auto transform transition-all"
    >
      <div class="modal-header flex justify-between items-center pb-6 border-b">
        <h5 class="text-2xl font-semibold text-gray-800" id="editarEventoModalLabel">
          Editar Evento
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
      <div class="modal-body overflow-y-auto w-full pt-4">
        <div v-if="errorMsg" class="mb-4 p-3 bg-red-100 text-red-800 rounded-lg">
          {{ errorMsg }}
        </div>
        <form @submit.prevent="actualizarEvento()" class="space-y-4">
          <div class="form-group mb-4">
            <label for="eventoTitulo" class="block text-sm font-medium text-gray-700">
              Título del Evento:
            </label>
            <input
              type="text"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoTitulo"
              v-model="evento.title"
              placeholder="Ingrese el título del evento"
              required
            />
          </div>
          <div class="form-group mb-4">
            <label for="eventoDescripcion" class="block text-sm font-medium text-gray-700">
              Descripción:
            </label>
            <textarea
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoDescripcion"
              v-model="evento.description"
              rows="3"
            ></textarea>
          </div>
          <div class="form-group mb-4">
            <label for="eventoFechaInicio" class="block text-sm font-medium text-gray-700">
              Fecha de inicio:
            </label>
            <input
              type="date"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoFechaInicio"
              v-model="evento.start"
              required
            />
          </div>
          <div class="form-group mb-4">
            <label for="eventoFechaFinal" class="block text-sm font-medium text-gray-700">
              Fecha Final:
            </label>
            <input
              type="date"
              class="form-control w-full mt-2 p-3 rounded-lg"
              id="eventoFechaFinal"
              v-model="evento.end"
              required
            />
          </div>
        </form>
      </div>
      <div
        class="modal-footer flex flex-col md:flex-row md:justify-between md:items-center gap-4 p-4 border-t"
      >
        <!-- Botones a la izquierda -->
        <div class="flex flex-col md:flex-row gap-4">
          <button
            type="button"
            class="flex items-center justify-center bg-blue-600 text-white py-2 px-6 rounded-lg hover:bg-blue-700 transition duration-200 w-full md:w-auto"
            @click="actualizarEvento"
          >
            Guardar Cambios
          </button>
          <button
            type="button"
            class="flex items-center justify-center bg-red-600 text-white py-2 px-6 rounded-lg hover:bg-red-700 transition duration-200 w-full md:w-auto"
            @click="deleteEvent"
          >
            Eliminar Evento
          </button>
        </div>

        <!-- Botón a la derecha -->
        <div class="flex justify-end">
          <button
            type="button"
            class="flex items-center justify-center bg-gray-300 text-black py-2 px-6 rounded-lg hover:bg-gray-400 transition duration-200 w-full md:w-auto"
            @click="cerrarModal"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { ref, watch } from 'vue'
import { EditarEvento, EliminarEvento } from '@/services/Calendario/CalendarioService'

export default {
  name: 'EditarEventoModal',
  props: {
    modalVisible: Boolean,
    eventoSeleccionado: Object,
  },
  setup(props, { emit }) {
    const evento = ref({ ...props.eventoSeleccionado })

    watch(
      () => props.eventoSeleccionado,
      (nuevoValor) => {
        evento.value = {
          ...nuevoValor,
        }
      },
      { immediate: true },
    )

    const mensaje = ref('') // Declaración de mensaje
    const errorMsg = ref('') // Declaración de errorMsg

    const actualizarEvento = async () => {
      console.log('Evento a guardar:', evento.value)
      const eventoData = {
        Id_Evento: evento.value.id,
        Nombre_Evento: evento.value.title,
        Descripcion: evento.value.description,
        Fecha_Inicio: evento.value.start,
        Fecha_Final: evento.value.end,
      }

      errorMsg.value = ''
      mensaje.value = ''

      // Verificar si no hubo cambios
      if (
        evento.value.title === props.eventoSeleccionado.title &&
        evento.value.description === props.eventoSeleccionado.description &&
        evento.value.start === props.eventoSeleccionado.start &&
        evento.value.end === props.eventoSeleccionado.end
      ) {
        errorMsg.value = 'No se realizaron cambios en el evento.'
        return
      }

      try {
        const respuesta = await EditarEvento(eventoData)
        mensaje.value = respuesta.Mensaje
        console.log('Evento guardado:', respuesta)
        cerrarModal()
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        errorMsg.value =
          error.response?.data?.detalle ||
          'Ocurrió un error al guardar el evento. Por favor, inténtelo de nuevo.'
        console.error('Error al guardar evento:', error)
      }

      emit('guardar-cambios', eventoData)
    }

    const deleteEvent = async () => {
      errorMsg.value = ''
      mensaje.value = ''
      try {
        await EliminarEvento(evento.value.id)
        mensaje.value = 'Evento eliminado correctamente'
        console.log('Evento eliminado:', evento.value.id)
        cerrarModal()
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        errorMsg.value =
          error.response?.data?.detalle ||
          'Ocurrió un error al eliminar el evento. Por favor, inténtelo de nuevo.'
        console.error('Error al eliminar evento:', error)
      }
    }

    const cerrarModal = () => {
      emit('cerrar')
    }

    return {
      evento,
      mensaje, // Asegúrate de retornar mensaje
      errorMsg, // Asegúrate de retornar errorMsg
      EditarEvento,
      cerrarModal,
      actualizarEvento,
      deleteEvent,
    }
  },
}
</script>
