<template>
  <div
    v-if="modalVisible"
    class="fixed inset-0 bg-black bg-opacity-60 flex items-center justify-center z-50"
  >
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-3xl p-8 relative">
      <!-- Botón cerrar -->
      <button
        @click="cerrarModal"
        class="absolute top-4 right-4 text-gray-500 hover:text-red-500 transition"
        aria-label="Cerrar"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-6 h-6"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>

      <!-- Título -->
      <div class="flex items-center gap-3 mb-6 border-b pb-4">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-7 h-7 text-indigo-600"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"
          />
        </svg>
        <h2 class="text-2xl md:text-3xl font-bold text-indigo-700">Detalles de la Familia</h2>
      </div>

      <!-- Mensaje de error -->
      <p v-if="errorMsg" class="text-red-600 mb-4 text-center font-medium">{{ errorMsg }}</p>

      <!-- Contenido -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 text-gray-800 text-base">
        <div v-for="(valor, campo) in camposMostrados" :key="campo">
          <p class="font-semibold text-gray-600">{{ campo }}:</p>
          <p :class="campo === 'Vulnerabilidad' ? claseVulnerabilidad(valor) : ''">
            {{ campo === 'Teléfono' ? formatearTelefono(valor) : valor }}
          </p>
        </div>
      </div>

      <!-- Botones -->
      <div class="flex flex-col sm:flex-row justify-center items-center gap-4 mt-8">
        <button
          @click="eliminarFamilias"
          class="inline-flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white font-medium py-2.5 px-6 rounded-lg shadow-md transition duration-200"
        >
          <span>Eliminar</span>
        </button>

        <button
          @click="cerrarModal"
          class="inline-flex items-center gap-2 bg-gray-100 hover:bg-gray-200 text-gray-800 font-medium py-2.5 px-6 rounded-lg shadow-md transition duration-200"
        >
          <span>Cerrar</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import { ObtenerFamiliaById, eliminarFamilia } from '@/services/Familias/FamiliasService'

const props = defineProps({
  modalVisible: { type: Boolean, required: true },
  idFamilia: { type: Number, required: true },
})

const emit = defineEmits(['cerrar'])

const errorMsg = ref('')
const familiaData = ref({
  id_familia: '',
  cedula_representante: '',
  Nombre_Representante: '',
  direccion: '',
  telefono: '',
  cantidad_familiares: '',
  cantidad_ninos: '',
  Id_Vulnerabilidad: '',
  Nombre_Vulnerabilidad: '',
  presupuesto: '',
})

const eliminarFamilias = async () => {
  if (!familiaData.value.id_familia) {
    errorMsg.value = 'No se puede eliminar una familia sin ID.'
    return
  }

  try {
    await eliminarFamilia(familiaData.value.id_familia)
    emit('cerrar')
    location.reload()
  } catch (error) {
    errorMsg.value = 'Error al eliminar la familia.'
    console.error(error)
  }
}

const camposMostrados = computed(() => ({
  'Cédula Representante': familiaData.value.cedula_representante,
  'Nombre Representante': familiaData.value.Nombre_Representante,
  Dirección: familiaData.value.direccion,
  Teléfono: familiaData.value.telefono,
  'Cantidad de Familiares': familiaData.value.cantidad_familiares,
  'Cantidad de Menores': familiaData.value.cantidad_ninos,
  Vulnerabilidad: familiaData.value.Nombre_Vulnerabilidad,
  Presupuesto: familiaData.value.presupuesto,
}))

const cerrarModal = () => emit('cerrar')

const claseVulnerabilidad = (valor) => {
  switch (valor?.toLowerCase()) {
    case 'alta':
      return 'text-red-600 font-bold'
    case 'media':
      return 'text-yellow-600 font-semibold'
    case 'baja':
      return 'text-blue-600 italic'
    default:
      return ''
  }
}
const formatearTelefono = (telefono) => {
  if (!telefono) return ''
  // Elimina cualquier caracter no numérico
  telefono = telefono.replace(/\D/g, '')

  // Verifica si el número tiene la longitud correcta (8 dígitos)
  if (telefono.length === 8) {
    return telefono.replace(/(\d{4})(\d{4})/, '$1-$2')
  }
  return telefono
}

const cargarDatosFamilia = async () => {
  if (!props.idFamilia || props.idFamilia === 0) {
    errorMsg.value = 'ID de familia inválido.'
    return
  }

  try {
    const datos = await ObtenerFamiliaById(props.idFamilia)
    if (datos.length > 0) {
      const familia = datos[0]
      familiaData.value = {
        id_familia: familia.Id_Familia,
        cedula_representante: familia.cedula_representante || '',
        Nombre_Representante: familia.Nombre_Representante || '',
        direccion: familia.direccion || '',
        telefono: familia.telefono || '',
        cantidad_familiares: familia.cantidad_familiares || '',
        cantidad_ninos: familia.cantidad_ninos || '',
        Id_Vulnerabilidad: familia.Id_Vulnerabilidad || '',
        Nombre_Vulnerabilidad: familia.Nombre_Vulnerabilidad || '',
        presupuesto: familia.presupuesto || 'No tiene presupuesto',
      }
      errorMsg.value = ''
    } else {
      throw new Error('Familia no encontrada')
    }
  } catch (error) {
    errorMsg.value = 'Error al cargar los datos de la familia.'
    console.error(error)
  }
}

watch(
  () => props.modalVisible,
  (nuevoValor) => {
    if (nuevoValor) cargarDatosFamilia()
  },
)
</script>
