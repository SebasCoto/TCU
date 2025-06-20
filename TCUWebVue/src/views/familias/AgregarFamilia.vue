<template>
  <div class="p-6 bg-white rounded-xl">
    <!-- Título -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-3xl font-bold text-indigo-700">Agregar Familia</h2>
    </div>
    <div v-if="errorMsg" class="rounded-xl shadow-md mb-4 p-4 bg-red-200 text-red-900" role="alert">
      <p class="text-sm font-semibold">{{ errorMsg }}</p>
    </div>
    <!-- Formulario -->
    <form @submit.prevent="guardarFamilia" class="space-y-6">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label for="apellidos" class="block text-sm font-medium text-gray-700"
            >Cedula Representante</label
          >
          <input
            v-model="familiaData.cedula_representante"
            id="cedRepre"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la cedula del representante"
            required
            @blur="consultarCedula"
          />
        </div>
        <!-- Nombre -->
        <div>
          <label for="nombre" class="block text-sm font-medium text-gray-700"
            >Nombre Representante</label
          >
          <input
            id="nombreRepre"
            v-model="familiaData.Nombre_Representante"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
            placeholder="Este espacio se autocompleta completando el de la cedula"
            readonly
          />
        </div>

        <!-- Apellidos -->

        <!-- Correo -->
        <div>
          <label for="direccion" class="block text-sm font-medium text-gray-700">Dirección</label>
          <input
            v-model="familiaData.direccion"
            id="direccion"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la direccion residencial de la familia"
          />
        </div>
        <div>
          <label for="telefono" class="block text-sm font-medium text-gray-700"
            >telefono de contacto</label
          >
          <input
            v-model="familiaData.telefono"
            id="telefono"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese el numero de telefono"
          />
        </div>
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
        <div>
          <label for="cantidad_ninos" class="block text-sm font-medium text-gray-700"
            >Cantidad de menores de edad</label
          >
          <input
            v-model="familiaData.cantidad_ninos"
            id="cantidad_ninos"
            type="number"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder="Ingrese la cantidad de menores de edad en la familia"
          />
        </div>
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
            <option
              v-for="vulnerabilidad in vulnerabilidades"
              :key="vulnerabilidad.id"
              :value="vulnerabilidad.id"
            >
              {{ vulnerabilidad.nombre }}
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
import { ObtenerVulnerabilidades, registrarFamilia } from '@/services/Familias/FamiliasService'
import router from '@/router'
const vulnerabilidades = ref([])
const loading = ref(false)

const familiaData = ref({
  cedula_representante: '',
  Nombre_Representante: '',
  direccion: '',
  telefono: '',
  cantidad_familiares: '',
  cantidad_ninos: '',
  Id_Vulnerabilidad: '',
})

const errorMsg = ref('')
const mensaje = ref('')

const cargarVulnerabilidades = async () => {
  loading.value = true
  try {
    const resultados = await ObtenerVulnerabilidades()
    vulnerabilidades.value = resultados.map((v) => ({
      id: v.id_vulnerabilidad,
      nombre: v.nombre,
    }))
  } catch (error) {
    console.error('Error al cargar vulnerabilidades:', error)
  } finally {
    loading.value = false
  }
}
const consultarCedula = async () => {
  if (familiaData.value.cedula_representante) {
    loading.value = true
    try {
      const response = await fetch(
        `https://apis.gometa.org/cedulas/${familiaData.value.cedula_representante}`,
      )

      if (!response.ok) {
        throw new Error('Error al consultar la API externa')
      }

      const data = await response.json()

      if (data && data.results && data.results.length > 0) {
        const result = data.results[0]

        familiaData.value.Nombre_Representante = result.fullname
      } else {
        errorMsg.value = 'No se encontraron datos para esta cédula'
      }
    } catch (error) {
      errorMsg.value = 'Error al consultar la API externa'
      console.error(error)
    } finally {
      loading.value = false // Termina el estado de carga
    }
  }
}

const guardarFamilia = async () => {
  errorMsg.value = ''
  mensaje.value = ''

  if (
    !familiaData.value.cedula_representante ||
    !familiaData.value.Nombre_Representante ||
    !familiaData.value.direccion ||
    !familiaData.value.telefono ||
    !familiaData.value.cantidad_familiares ||
    !familiaData.value.cantidad_ninos ||
    !familiaData.value.Id_Vulnerabilidad
  ) {
    errorMsg.value = 'Por favor complete todos los campos.'
    return
  }

  try {
    const respuesta = await registrarFamilia(familiaData.value)
    mensaje.value = respuesta.mensaje
    router.push('/obtenerFamilias')
  } catch (error) {
    if (error.response && error.response.data && error.response.data.Mensaje) {
      errorMsg.value = error.response.data.Mensaje
    } else {
      errorMsg.value = error.message
    }
    console.error('Error al registrar:', error)
  }
}

onMounted(async () => {
  await cargarVulnerabilidades()
})
</script>
