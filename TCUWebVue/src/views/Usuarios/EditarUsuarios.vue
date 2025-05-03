<template>
  <div class="p-6 bg-white rounded-xl">
    <!-- Título -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-3xl font-bold text-indigo-700">Editar Voluntario</h2>
    </div>
    <div v-if="errorMsg" class="mb-4 p-3 bg-red-100 text-red-800 rounded-lg border border-red-300">
      {{ errorMsg }}
    </div>

    <!-- Formulario -->
    <form @submit.prevent="guardarCambios" class="space-y-6">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Nombre -->
        <div>
          <label for="nombre" class="block text-sm font-medium text-gray-700">Nombre</label>
          <input
            id="nombre"
            v-model="voluntario.nombreUsuario"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
            placeholder="Nombre"
            readonly
          />
        </div>

        <!-- Apellidos -->
        <div>
          <label for="apellidos" class="block text-sm font-medium text-gray-700">Apellidos</label>
          <input
            id="apellidos"
            v-model="voluntario.apellidos"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
            placeholder="Apellidos"
            readonly
          />
        </div>

        <!-- Correo -->
        <div>
          <label for="correo" class="block text-sm font-medium text-gray-700">Correo</label>
          <input
            id="correo"
            v-model="voluntario.correo"
            type="email"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
            placeholder="ejemplo@correo.com"
            readonly
          />
        </div>
        <div>
          <label for="username" class="block text-sm font-medium text-gray-700"
            >Nombre de usuario</label
          >
          <input
            id="username"
            v-model="voluntario.username"
            type="email"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
            readonly
          />
        </div>
        <div>
          <label for="rol" class="block text-sm font-medium text-gray-700">Rol</label>
          <select
            id="rol"
            v-model="voluntario.Id_rol"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          >
            <option disabled value="">Seleccione un rol</option>
            <option v-for="rol in roles" :key="rol.id" :value="rol.id">
              {{ rol.nombre }}
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
          to="/obtenerUsuarios"
          class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-6 rounded-lg transition shadow-md"
        >
          Cancelar
        </router-link>
      </div>
    </form>

    <!-- Mensaje de éxito -->
    <div v-if="mensaje" class="mt-6 text-green-600 text-center font-medium">
      {{ mensaje }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ObtenerUsuarioById, ActualizarUsuario } from '@/services/Usuarios/UsuariosService'
import { obtenerRoles } from '@/services/perfil/perfilServices'
import Swal from 'sweetalert2'

const route = useRoute()
const router = useRouter()

const voluntario = ref({
  nombre: '',
  apellidos: '',
  correo: '',
  telefono: '',
  disponibilidad: '',
  username: '',
  id_Rol: '',
  nombreRol: '',
})

const errorMsg = ref('')
const mensaje = ref('')
const roles = ref([])
const loading = ref(false)
const idUsuario = route.params.id

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

onMounted(async () => {
  try {
    const datos = await ObtenerUsuarioById(idUsuario)
    const usuario = datos[0]
    if (datos) {
      voluntario.value = {
        id_usuario: usuario.Id_usuario,
        nombreUsuario: usuario.NombreUsuario || '',
        apellidos: usuario.Apellidos || '',
        correo: usuario.Correo || '',
        Id_rol: usuario.IdRol || '', // Cambiado a Id_rol
        nombreRol: usuario.NombreRol || '',
        username: usuario.Username,
      }

      await cargarRoles()

      // Sincroniza Id_rol con el nombre del rol si es necesario
      const rolEncontrado = roles.value.find((rol) => rol.nombre === voluntario.value.nombreRol)
      if (rolEncontrado) {
        voluntario.value.Id_rol = rolEncontrado.id
      }
    } else {
      throw new Error('Datos no encontrados')
    }
  } catch (error) {
    errorMsg.value = 'Error al cargar los datos del voluntario.'
    console.error(error)
  }
})

const guardarCambios = async () => {
  errorMsg.value = ''
  mensaje.value = ''

  if (
    voluntario.value.nombreRol ===
    roles.value.find((rol) => rol.id === voluntario.value.Id_rol)?.nombre
  ) {
    errorMsg.value = 'No se realizaron cambios en el rol.'
    return
  }

  try {
    if (voluntario.value.Id_rol === '') {
      errorMsg.value = 'El rol no puede ser nulo.'
      return
    }
    const respuesta = await ActualizarUsuario(voluntario.value)
    mensaje.value = respuesta.mensaje
    Swal.fire({
      icon: 'success',
      title: 'Éxito',
      text: 'Voluntario actualizado correctamente',
    })
    router.push('/obtenerUsuarios')
  } catch (error) {
    errorMsg.value = error.message
    console.error(error)
  }
}
</script>
