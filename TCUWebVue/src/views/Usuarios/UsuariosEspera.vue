<template>
  <div class="max-w-screen-xl mx-auto p-5 sm:p-10 md:p-16 bg-gray-50 min-h-screen">
    <h1 class="text-3xl font-extrabold text-center text-indigo-700 mb-10">Usuarios en espera</h1>

    <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
      <!-- Filtro por nombre -->
      <div class="relative w-full sm:w-1/2">
        <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-5 h-5 text-blue-500"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"
            />
          </svg>
        </span>
        <input
          v-model="filtroNombre"
          type="text"
          placeholder="Buscar por nombre..."
          class="border border-gray-300 pl-10 pr-4 py-3 rounded-lg w-full focus:ring-2 focus:ring-blue-400 transition-all duration-300 ease-in-out transform hover:scale-105"
        />
      </div>

      <!-- Filtro por rol -->
      <div class="relative w-full sm:w-1/3">
        <select
          v-model="filtroRol"
          class="w-full p-3 border border-gray-300 rounded-lg text-sm font-semibold transition duration-300 ease-in-out focus:ring-2 focus:ring-blue-400 hover:scale-105"
        >
          <option value="">Todos los roles</option>
          <option v-for="rol in roles" :key="rol.id" :value="rol.nombre">
            {{ rol.nombre }}
          </option>
        </select>
      </div>
    </div>

    <div v-if="usuariosFiltrados.length === 0" class="text-center text-gray-600 py-6">
      <p>No hay solicitudes pendientes.</p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      <div
        v-for="usuario in usuariosFiltrados"
        :key="usuario.id"
        class="rounded-lg overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300 ease-in-out bg-white w-full border border-gray-200"
      >
        <div class="px-6 py-4">
          <p class="font-semibold text-xl text-indigo-700 mb-2">
            {{ usuario.nombre }} {{ usuario.apellido }}
          </p>
          <ul class="text-gray-600 text-sm space-y-1">
            <li><strong>Correo:</strong> {{ usuario.correo }}</li>
          </ul>
          <div class="flex justify-end space-x-2 mt-4">
            <button
              @click="abrirModal(usuario.correo, usuario.id)"
              class="flex items-center gap-1 bg-green-400 hover:bg-green-600 text-white px-3 py-1 rounded text-sm transition"
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
                  d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652
                 L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1
                 1.13-1.897l8.932-8.931Z"
                />
              </svg>
              Editar Acceso
            </button>

            <modalAccesoUsuarios
              :modalVisible="modalEditarAccesoVisible"
              :correoUsuario="correoSeleccionado"
              :idUsuario="idUsuario"
              @cerrar="modalEditarAccesoVisible = false"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ObtenerUsuariosEspera } from '@/services/UsuariosEspera/UsuariosEsperaService'
import { obtenerRoles } from '@/services/perfil/perfilServices'

const filtroNombre = ref('')
const listaEspera = ref([])
const modalEditarAccesoVisible = ref(false)
import modalAccesoUsuarios from '@/components/UsuariosEspera/modalAccesoUsuarios.vue'
const correoSeleccionado = ref('')
const idUsuario = ref(0)
const roles = ref([])
const filtroRol = ref('')

const loading = ref(false)

const cargarRoles = async () => {
  loading.value = true
  try {
    const resultados = await obtenerRoles()
    roles.value = resultados.map((rol) => ({
      id: rol.id_rol,
      nombre: rol.nombre,
    }))
  } catch (error) {
    console.error('Error al cargar roles:', error)
  } finally {
    loading.value = false
  }
}

const usuariosFiltrados = computed(() =>
  listaEspera.value.filter((v) => {
    const coincideNombre =
      v.nombre.toLowerCase().includes(filtroNombre.value.toLowerCase()) ||
      v.apellidos.toLowerCase().includes(filtroNombre.value.toLowerCase())
    const coincideRol = !filtroRol.value || v.nombreRol === filtroRol.value
    return coincideNombre && coincideRol
  }),
)

const obtenerUsuariosEspera = async () => {
  const resultados = await ObtenerUsuariosEspera()
  listaEspera.value = resultados.map((v) => ({
    id: v.Id_usuario,
    nombre: v.NombreUsuario,
    apellidos: v.Apellidos,
    correo: v.Correo,
    Idrol: v.Id_Rol,
    nombreRol: v.NombreRol,
    nombreEstado: v.NombreEstadoRegistro,
  }))
}

const abrirModal = (correo, id) => {
  idUsuario.value = Number(id)
  correoSeleccionado.value = correo
  modalEditarAccesoVisible.value = true
}
onMounted(() => {
  obtenerUsuariosEspera()
  cargarRoles()
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
