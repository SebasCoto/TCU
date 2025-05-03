<template>
  <div
    v-if="modalVisible"
    class="fixed inset-0 bg-gray-800 bg-opacity-60 flex items-center justify-center z-50 transition-opacity duration-300"
  >
    <div
      class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl p-8 max-h-[90vh] overflow-y-auto transform transition-all scale-100"
    >
      <!-- Header -->
      <div class="flex justify-between items-center border-b pb-4 mb-6">
        <div class="flex items-center gap-3">
          <i class="fas fa-calendar-alt text-2xl text-blue-600"></i>
          <h2 class="text-2xl font-semibold text-gray-800">Detalles del Evento</h2>
        </div>
        <button @click="cerrarModal" class="text-gray-400 hover:text-gray-600 transition">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-6 h-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
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

      <!-- Content -->
      <div class="space-y-6 text-gray-700">
        <div>
          <p class="text-sm font-semibold text-gray-500">Título</p>
          <p class="text-lg">{{ evento.title }}</p>
        </div>
        <div>
          <p class="text-sm font-semibold text-gray-500">Descripción</p>
          <p class="text-base whitespace-pre-line">{{ evento.description }}</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <p class="text-sm font-semibold text-gray-500">Fecha de Inicio</p>
            <p class="text-base">{{ evento.start }}</p>
          </div>
          <div>
            <p class="text-sm font-semibold text-gray-500">Fecha Final</p>
            <p class="text-base">{{ evento.end || 'No disponible' }}</p>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="mt-8 flex justify-end">
        <button
          @click="cerrarModal"
          class="px-6 py-2 bg-gray-100 text-gray-800 rounded-lg hover:bg-gray-200 transition duration-200"
        >
          Cerrar
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch } from 'vue'
export default {
  name: 'DetallesEventoModal',
  props: {
    modalVisible: {
      type: Boolean,
      required: true,
    },
    eventoSeleccionado: {
      type: Object,
      required: true,
    },
  },
  setup(props, { emit }) {
    const evento = ref(props.eventoSeleccionado)
    const mensaje = ref('')
    const errorMsg = ref('')
    watch(
      () => props.eventoSeleccionado,
      (nuevoValor) => {
        console.log('Nuevo valor recibido:', nuevoValor)
        evento.value = {
          ...nuevoValor,
        }
      },
      { immediate: true },
    )

    const cerrarModal = () => {
      emit('cerrar')
    }
    return {
      evento,
      mensaje,
      errorMsg,
      cerrarModal,
    }
  },
}
</script>

<style scoped></style>
