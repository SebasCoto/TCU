<template>
  <!-- Mensaje de error -->
  <div v-if="errorMsg" class="mb-4 p-3 bg-red-100 text-red-800 rounded-lg border border-red-300">
    {{ errorMsg }}
  </div>

  <!-- Título -->
  <div class="flex items-center justify-between mb-8">
    <h2 class="text-3xl font-bold text-gray-800">Editar Perfil</h2>
    <router-link
      to="/cambiarContrasena"
      class="flex items-center gap-2 text-sm sm:text-base text-blue-600 hover:text-blue-800 font-medium transition"
    >
      <i class="fas fa-key"></i>
      Cambiar contraseña
    </router-link>
  </div>

  <!-- Formulario -->
  <form @submit.prevent="actualizar" class="space-y-6">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Nombre -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Nombre</label>
        <input
          v-model="perfil.NombreUsuario"
          type="text"
          class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
          placeholder="Nombre"
          readonly
        />
      </div>

      <!-- Apellidos -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Apellidos</label>
        <input
          v-model="perfil.apellidos"
          type="text"
          class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
          placeholder="Apellidos"
          readonly
        />
      </div>

      <!-- Rol -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Rol</label>
        <input
          v-model="perfil.nombreRol"
          class="w-full mt-1 p-3 border border-gray-300 rounded-lg bg-gray-100"
          readonly
        />
      </div>

      <!-- Username -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Username</label>
        <input
          v-model="perfil.username"
          type="text"
          class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          placeholder="Nombre de usuario"
        />
      </div>

      <!-- Correo -->
      <div class="col-span-1 md:col-span-2">
        <label class="block text-sm font-medium text-gray-700">Correo</label>
        <input
          v-model="perfil.correo"
          type="email"
          class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          placeholder="ejemplo@correo.com"
        />
      </div>
    </div>

    <!-- Botones -->
    <div class="flex flex-col sm:flex-row gap-4 justify-center mt-8">
      <button
        type="submit"
        class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg transition shadow-md"
      >
        Guardar Cambios
      </button>

      <router-link
        to="/home"
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
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { obtenerPerfil, actualizarPerfil } from '@/services/perfil/perfilServices'
import Swal from 'sweetalert2'
import { useLoginStore } from '@/stores/Login/LoginStore'
const perfil = reactive({
  NombreUsuario: '',
  apellidos: '',
  correo: '',
  username: '',
  id_Rol: '',
  nombreRol: '',
})

const mensaje = ref('')
const errorMsg = ref('')

const obtenerDatosPerfil = async () => {
  try {
    const data = await obtenerPerfil()
    console.log('Datos obtenidos del API:', data)

    const usuario = data[0]

    if (usuario) {
      perfil.NombreUsuario = usuario.NombreUsuario || ''
      console.log('Nombre asignado:', perfil.NombreUsuario)
      perfil.apellidos = usuario.Apellidos || ''
      perfil.correo = usuario.Correo || ''
      perfil.username = usuario.Username || ''
      perfil.id_Rol = usuario.Id_Rol || ''
      perfil.nombreRol = usuario.NombreRol || ''
    } else {
      console.error('El array de datos está vacío.')
    }
  } catch (error) {
    console.error('Error al obtener los datos del perfil:', error)
  }
}

const loginStore = useLoginStore()
const actualizar = async () => {
  errorMsg.value = ''
  mensaje.value = ''

  if (
    loginStore.nombreUsuario === perfil.NombreUsuario &&
    loginStore.apellidos === perfil.apellidos &&
    loginStore.correo === perfil.correo &&
    loginStore.userName === perfil.username
  ) {
    errorMsg.value = 'No se realizaron cambios en el evento.'
    return
  }

  try {
    const respuesta = await actualizarPerfil(perfil)
    mensaje.value = respuesta.mensaje

    loginStore.nombreUsuario = perfil.NombreUsuario
    loginStore.apellidos = perfil.apellidos
    loginStore.correo = perfil.correo
    loginStore.userName = perfil.username

    Swal.fire({
      icon: 'success',
      title: 'Éxito',
      text: 'Perfil actualizado correctamente',
    })
  } catch (error) {
    errorMsg.value = error.message
    console.error(error)
  }
}

onMounted(() => {
  obtenerDatosPerfil()
})
</script>

<style scoped>
/* Puedes agregar estilos personalizados aquí */
</style>
