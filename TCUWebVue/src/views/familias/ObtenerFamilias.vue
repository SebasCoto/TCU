<template>
  <div class="text-center mb-6">
    <h1 class="text-2xl font-bold text-indigo-700">Gestión de Familias</h1>
  </div>

  <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
    <!-- Filtro por nombre -->
    <div class="relative w-full sm:w-1/2 lg:w-1/3">
      <input
        v-model="filtroNombre"
        type="text"
        placeholder="Buscar por nombre..."
        class="border font-semibold border-gray-300 pl-10 pr-4 py-3 rounded-lg w-full focus:ring-2 focus:ring-blue-400 transition-all duration-300 ease-in-out transform hover:scale-105"
      />
    </div>

    <!-- Filtro por vulnerabilidad -->
    <div class="relative w-full sm:w-1/2 lg:w-1/3">
      <select
        v-model="filtroVulnerabilidad"
        class="w-full p-3 border border-gray-300 rounded-lg text-sm font-semibold transition duration-300 ease-in-out focus:ring-2 focus:ring-blue-400 hover:scale-105"
      >
        <option value="">Todas las vulnerabilidades</option>
        <option v-for="v in vulnerabilidades" :key="v.id" :value="v.id">
          {{ v.nombre }}
        </option>
      </select>
    </div>

    <!-- Botón de agregar familia -->
    <div class="w-full sm:w-auto lg:w-1/3 flex justify-center sm:justify-end mt-4 sm:mt-0">
      <router-link
        to="/agregarFamilia"
        class="flex items-center gap-2 bg-green-500 hover:bg-green-700 text-white px-4 py-2 rounded text-sm transition"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-5 h-5"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
        </svg>
        Agregar
      </router-link>
    </div>
  </div>

  <div v-if="!familiasFiltradas.length" class="text-center text-gray-600 py-6">
    <p>No hay familias disponibles.</p>
  </div>

  <!-- Cards de familias -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
    <div
      v-for="familia in familiasFiltradas"
      :key="familia.id"
      class="rounded-lg overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300 ease-in-out bg-white w-full border border-gray-200 flex flex-col"
    >
      <div class="px-6 py-4 flex-grow">
        <p class="font-semibold text-xl text-indigo-700 mb-2">
          Familia: {{ obtenerApellidos(familia.nombreRepre) }}
        </p>
        <ul class="text-gray-600 text-sm space-y-1">
          <li><strong>Nombre representante:</strong> {{ familia.nombreRepre }}</li>
          <li><strong>Teléfono:</strong> {{ familia.telefono }}</li>
          <li>
            <strong>Miembros Totales:</strong>
            {{ miembrosTotales(familia.cantFamiliares, familia.cantNinos) }}
          </li>
        </ul>
      </div>

      <!-- Botones -->
      <div class="flex justify-end space-x-2 p-2">
        <button
          @click="abrirModal(familia.id)"
          class="flex items-center gap-1 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm transition-all duration-300 ease-in-out hover:scale-105"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-4 h-4"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
          </svg>
          Ver Detalles
        </button>

        <router-link
          :to="{ name: 'editarFamilia', params: { id: familia.id } }"
          class="flex items-center gap-1 bg-yellow-500 hover:bg-yellow-600 text-white px-4 py-2 rounded-md text-sm transition-all duration-300 ease-in-out hover:scale-105"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-4 h-4"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931Z"
            />
          </svg>
          Editar
        </router-link>
      </div>
    </div>
  </div>

  <!-- Modal de Detalles -->
  <DetallesFamilias
    :modalVisible="modalDetalleFamiliaVisible"
    :idFamilia="idFamilia"
    @cerrar="modalDetalleFamiliaVisible = false"
  />
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ObtenerFamilias, ObtenerVulnerabilidades } from '@/services/Familias/FamiliasService'
import DetallesFamilias from '@/components/Familias/DetallesFamilias.vue'

const familias = ref([])
const vulnerabilidades = ref([])

const filtroNombre = ref('')
const filtroVulnerabilidad = ref('')
const modalDetalleFamiliaVisible = ref(false)
const idFamilia = ref(0)

const obtenerFamilias = async () => {
  try {
    const data = await ObtenerFamilias()
    familias.value = data.map((f) => ({
      id: f.Id_Familia,
      nombreRepre: f.Nombre_Representante,
      cedulaRepre: f.cedula_representante,
      direccion: f.direccion,
      telefono: f.telefono,
      cantFamiliares: f.cantidad_familiares,
      cantNinos: f.cantidad_ninos,
      presupuesto: f.presupuesto,
      idVulnerabilidad: Number(f.Id_Vulnerabilidad),
      nombreVulnerabilidad: f.Nombre_Vulnerabilidad,
    }))
  } catch (err) {
    console.error('Error al obtener familias:', err)
  }
}

const cargarVulnerabilidades = async () => {
  try {
    const data = await ObtenerVulnerabilidades()
    vulnerabilidades.value = data.map((v) => ({
      id: Number(v.id_vulnerabilidad),
      nombre: v.nombre,
    }))
  } catch (err) {
    console.error('Error al cargar vulnerabilidades:', err)
  }
}

const abrirModal = (id) => {
  idFamilia.value = Number(id)
  modalDetalleFamiliaVisible.value = true
}

const obtenerApellidos = (nombreCompleto) => {
  if (!nombreCompleto) return ''
  const palabras = nombreCompleto.trim().split(' ')
  return palabras.slice(-2).join(' ')
}

const miembrosTotales = (adultos, ninos) => {
  return (Number(adultos) || 0) + (Number(ninos) || 0)
}

const familiasFiltradas = computed(() => {
  return familias.value.filter((f) => {
    const coincideNombre = f.nombreRepre.toLowerCase().includes(filtroNombre.value.toLowerCase())
    const coincideVulnerabilidad = filtroVulnerabilidad.value
      ? f.idVulnerabilidad === Number(filtroVulnerabilidad.value)
      : true
    return coincideNombre && coincideVulnerabilidad
  })
})

onMounted(() => {
  obtenerFamilias()
  cargarVulnerabilidades()
})
</script>

<style scoped>
button {
  transition:
    transform 0.3s ease,
    background-color 0.3s ease;
}
button:hover {
  transform: scale(1.05);
}
</style>
