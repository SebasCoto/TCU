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
      <div class="modal-body overflow-y-auto w-full">
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
            <p>Correos seleccionados: {{ selectedCorreos }}</p>
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
import { ref, watch } from 'vue'
import Multiselect from 'vue-multiselect'
import {
  obtenerCorreos,
  guardarEvento as guardarEventoService,
} from '@/services/Calendario/CalendarioService.js'

export default {
  name: 'CrearEventoModal',
  components: {
    Multiselect,
  },
  props: {
    modalVisible: Boolean,
  },
  emits: ['cerrar'],
  setup(props, { emit }) {
    const correos = ref([])
    const selectedCorreos = ref([])
    const loading = ref(false)
    const mensaje = ref('')
    const errorMsg = ref('')
    const evento = ref({
      titulo: '',
      descripcion: '',
      fechaInicio: '',
      fechaFinal: '', // Agregada aquí
      color: '#ffffff',
    })

    const cargarCorreos = async () => {
      loading.value = true
      try {
        const resultados = await obtenerCorreos('')
        correos.value = resultados.map((correo) => ({
          id: correo.id,
          text: correo.text,
        }))
      } catch (error) {
        console.error('Error al cargar correos:', error)
      } finally {
        loading.value = false
      }
    }

    const buscarCorreos = async (query) => {
      if (!query) return
      loading.value = true
      try {
        const resultados = await obtenerCorreos(query)
        correos.value = resultados.map((correo) => ({
          id: correo.id,
          text: correo.text,
        }))
      } catch (error) {
        console.error('Error al buscar correos:', error)
      } finally {
        loading.value = false
      }
    }

    watch(
      () => props.modalVisible,
      (nuevoValor) => {
        if (nuevoValor) {
          console.log('Modal abierto, cargando correos...')
          cargarCorreos() // Solo cargar correos cuando el modal esté abierto
        } else {
          console.log('Modal cerrado, limpiando datos...')
          correos.value = [] // Limpia los datos si es necesario
          selectedCorreos.value = []
          errorMsg.value = ''
          mensaje.value = ''
        }
      },
    )

    const guardarEvento = async () => {
      console.log('Intentando guardar el evento...')

      const eventoData = {
        Nombre_Evento: evento.value.titulo,
        Descripcion: evento.value.descripcion,
        Fecha_Inicio: evento.value.fechaInicio,
        Fecha_Final: evento.value.fechaFinal,
        Color: evento.value.color,
        Invitados: selectedCorreos.value.map((correo) => correo.id).join(','), // Convertir a cadena separada por comas
      }

      console.log('Datos del evento a enviar:', eventoData)

      errorMsg.value = ''
      mensaje.value = ''

      try {
        const respuesta = await guardarEventoService(eventoData)
        mensaje.value = respuesta.Mensaje
        console.log('Evento guardado:', respuesta)
        cerrarModal()
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        errorMsg.value = error.response?.data?.detalle || error.message
        console.error('Error al guardar evento:', error)
      }
    }

    const cerrarModal = () => {
      emit('cerrar')
    }

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
