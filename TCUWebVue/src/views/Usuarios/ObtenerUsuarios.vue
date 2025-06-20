<template>
  <div class="max-w-screen-xl mx-auto p-5 sm:p-10 md:p-16 bg-gray-50 min-h-screen">
    <h1 class="text-3xl font-extrabold text-center text-indigo-700 mb-10">Usuarios</h1>

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
        <span class="absolute top-1/2 transform -translate-y-1/2 text-gray-400"></span>
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

    <div
      v-if="!todosLosVoluntarios.length || !voluntarios.length"
      class="text-center text-gray-600 py-6"
    >
      <p>No hay usuarios disponibles.</p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      <div
        v-for="voluntario in voluntarios"
        :key="voluntario.id"
        class="rounded-lg overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300 ease-in-out bg-white w-full border border-gray-200"
      >
        <div class="px-6 py-4">
          <p class="font-semibold text-xl text-indigo-700 mb-2">
            {{ voluntario.nombre }} {{ voluntario.apellido }}
          </p>
          <ul class="text-gray-600 text-sm space-y-1">
            <li><strong>Correo:</strong> {{ voluntario.correo }}</li>
            <li><strong>Nombre de usuario:</strong> {{ voluntario.username }}</li>
            <li><strong>Rol:</strong> {{ voluntario.nombreRol }}</li>
          </ul>
          <!-- Botones de acción -->
          <div class="flex justify-end space-x-2 mt-4">
            <!-- Botón Editar -->
            <router-link
              :to="{ name: 'EditarUsuario', params: { id: voluntario.id } }"
              class="flex items-center gap-1 bg-yellow-400 hover:bg-yellow-500 text-white px-3 py-1 rounded text-sm transition"
            >
              <!-- Icono y texto -->
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
              Editar
            </router-link>

            <!-- Botón Eliminar -->
            <button
              @click="() => deleteUser(voluntario.id)"
              class="flex items-center gap-1 bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-sm transition"
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
                  d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107
                         1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25
                         2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397
                         m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5
                         0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09
                         1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"
                />
              </svg>
              Eliminar
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted, computed } from 'vue'
import { ObtenerVoluntarios, EliminarUsuario } from '@/services/Usuarios/UsuariosService'
import { obtenerRoles } from '@/services/perfil/perfilServices'
import Swal from 'sweetalert2'
const filtroNombre = ref('')
const filtroRol = ref('')
const loading = ref(false)
const todosLosVoluntarios = ref([])
const roles = ref([])

const voluntarios = computed(() =>
  todosLosVoluntarios.value.filter((v) => {
    const coincideNombre =
      v.nombre.toLowerCase().includes(filtroNombre.value.toLowerCase()) ||
      v.apellidos.toLowerCase().includes(filtroNombre.value.toLowerCase())

    const coincideRol =
      !filtroRol.value || v.nombreRol?.toLowerCase() === filtroRol.value.toLowerCase()

    return coincideNombre && coincideRol
  }),
)
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

const obtenerVoluntarios = async () => {
  const resultados = await ObtenerVoluntarios()
  todosLosVoluntarios.value = resultados.map((v) => ({
    id: v.Id_usuario,
    nombre: v.NombreUsuario,
    apellidos: v.Apellidos,
    correo: v.Correo,
    Idrol: v.Id_Rol,
    nombreRol: v.NombreRol,
    username: v.Username,
  }))
}

const deleteUser = async (id) => {
  Swal.fire({
    title: '¿Está seguro de que desea eliminar el usuario?',
    text: 'Una vez realizada esta acción no se podrá revertir.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Sí, Eliminar!',
    cancelButtonText: 'Cancelar',
  }).then(async (result) => {
    if (result.isConfirmed) {
      try {
        await EliminarUsuario(id)

        // Actualizar la lista de usuarios eliminando el usuario eliminado
        todosLosVoluntarios.value = todosLosVoluntarios.value.filter(
          (voluntario) => voluntario.id !== id,
        )

        Swal.fire({
          icon: 'success',
          title: '¡Usuario eliminado!',
          text: 'El usuario ha sido eliminado exitosamente.',
          confirmButtonText: 'Aceptar',
        })
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text:
            error.response?.data?.detalle ||
            'Ocurrió un error al eliminar el usuario. Por favor, inténtelo de nuevo.',
          confirmButtonText: 'Aceptar',
        })
      }
    }
  })
}
onMounted(() => {
  obtenerVoluntarios()
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
