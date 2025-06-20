<template>
  <div class="p-6 bg-white rounded-xl">
    <!-- Título -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-3xl font-bold text-indigo-700">Editar Familia</h2>
    </div>

    <div v-if="errorMsg" class="rounded-xl shadow-md mb-4 p-4 bg-red-200 text-red-900" role="alert">
      <p class="text-sm font-semibold">{{ errorMsg }}</p>
    </div>

    <!-- Formulario -->
    <form @submit.prevent="guardarFamilia" class="space-y-6">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Cédula -->
        <div>
          <label for="cedRepre" class="block text-sm font-medium text-gray-700"
            >Cédula Representante</label
          >
          <input
            v-model="familiaData.cedula_representante"
            id="cedRepre"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la cédula del representante"
            required
            @change="consultarCedula"
          />
        </div>

        <!-- Nombre -->
        <div>
          <label for="nombreRepre" class="block text-sm font-medium text-gray-700"
            >Nombre Representante</label
          >
          <input
            id="nombreRepre"
            v-model="familiaData.Nombre_Representante"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
            placeholder="Este espacio se autocompleta con la cédula"
            readonly
          />
        </div>

        <!-- Dirección -->
        <div>
          <label for="direccion" class="block text-sm font-medium text-gray-700">Dirección</label>
          <input
            v-model="familiaData.direccion"
            id="direccion"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la dirección residencial de la familia"
          />
        </div>

        <!-- Teléfono -->
        <div>
          <label for="telefono" class="block text-sm font-medium text-gray-700"
            >Teléfono de contacto</label
          >
          <input
            v-model="familiaData.telefono"
            id="telefono"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese el número de teléfono"
          />
        </div>

        <!-- Cantidad de familiares -->
        <div>
          <label for="cantidad_familiares" class="block text-sm font-medium text-gray-700"
            >Cantidad de familiares</label
          >
          <input
            v-model="familiaData.cantidad_familiares"
            id="cantidad_familiares"
            type="number"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la cantidad de familiares"
          />
        </div>

        <!-- Cantidad de niños -->
        <div>
          <label for="cantidad_ninos" class="block text-sm font-medium text-gray-700"
            >Cantidad de menores de edad</label
          >
          <input
            v-model="familiaData.cantidad_ninos"
            id="cantidad_ninos"
            type="number"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la cantidad de menores de edad"
          />
        </div>

        <!-- Vulnerabilidad -->
        <div>
          <label for="vulnerabilidad" class="block text-sm font-medium text-gray-700"
            >Vulnerabilidad de la familia</label
          >
          <select
            id="vulnerabilidad"
            v-model="familiaData.Id_Vulnerabilidad"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          >
            <option disabled value="">Seleccione una vulnerabilidad</option>
            <option v-for="v in vulnerabilidades" :key="v.id" :value="v.id">
              {{ v.nombre }}
            </option>
          </select>
        </div>
      </div>

      <!-- Botones -->
      <div class="flex flex-col sm:flex-row gap-4 justify-center mt-6">
        <button
          type="submit"
          class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2 px-6 rounded-lg transition shadow-md"
        >
          Guardar Cambios
        </button>

        <router-link
          to="/obtenerFamilias"
          class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-6 rounded-lg transition shadow-md"
        >
          Cancelar
        </router-link>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  ObtenerFamiliaById,
  ObtenerVulnerabilidades,
  actualizarFamilia,
} from '@/services/Familias/FamiliasService'
import Swal from 'sweetalert2'

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
})

const router = useRouter()
const errorMsg = ref('')
const loading = ref(false)
const vulnerabilidades = ref([])

const familiaData = ref({
  id_familia: '',
  cedula_representante: '',
  Nombre_Representante: '',
  direccion: '',
  telefono: '',
  cantidad_familiares: '',
  cantidad_ninos: '',
  Id_Vulnerabilidad: '',
})

const cargarVulnerabilidades = async () => {
  try {
    const resultados = await ObtenerVulnerabilidades()
    vulnerabilidades.value = resultados.map((v) => ({
      id: v.id_vulnerabilidad,
      nombre: v.nombre,
    }))
  } catch (error) {
    console.error('Error al cargar vulnerabilidades:', error)
  }
}

const consultarCedula = async () => {
  if (!familiaData.value.cedula_representante) return
  try {
    loading.value = true
    const response = await fetch(
      `https://apis.gometa.org/cedulas/${familiaData.value.cedula_representante}`,
    )
    if (!response.ok) throw new Error('Error al consultar la API externa')
    const data = await response.json()
    if (data.results && data.results.length > 0) {
      familiaData.value.Nombre_Representante = data.results[0].fullname
    } else {
      errorMsg.value = 'No se encontraron datos para esta cédula.'
    }
  } catch (error) {
    errorMsg.value = 'Error al consultar la API externa.'
    console.error(error)
  } finally {
    loading.value = false
  }
}

const guardarFamilia = async () => {
  try {
    await actualizarFamilia(familiaData.value)
    Swal.fire({
      title: '¡Se ha actualizado la familia con éxito!',
      icon: 'success',
      timer: 2000,
      showConfirmButton: false,
      timerProgressBar: true,
    }).then(() => {
      router.push('/obtenerFamilias')
    })
  } catch (error) {
    errorMsg.value = 'Error al guardar la familia.'
    console.error(error)
  }
}

onMounted(async () => {
  try {
    const datos = await ObtenerFamiliaById(props.id)
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
      }
    } else {
      throw new Error('Familia no encontrada')
    }

    await cargarVulnerabilidades()
  } catch (error) {
    errorMsg.value = 'Error al cargar los datos de la familia.'
    console.error(error)
  }
})
</script>
