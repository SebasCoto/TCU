<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '@/services/Login/Login'

// Datos del formulario
const usuario = ref({
  Username: '',
  Password: '',
  NombreUsuario: '',
  Apellidos: '',
  Cedula: '',
  Email: '',
  Telefono: '',
})

const mensaje = ref('')
const errorMsg = ref('')
const cargando = ref(false)

//
const router = useRouter()

const consultarCedula = async () => {
  if (usuario.value.Cedula) {
    cargando.value = true
    try {
      const response = await fetch(`https://apis.gometa.org/cedulas/${usuario.value.Cedula}`)

      if (!response.ok) {
        throw new Error('Error al consultar la API externa')
      }

      const data = await response.json()

      if (data && data.results && data.results.length > 0) {
        const result = data.results[0]

        usuario.value.NombreUsuario = result.lastname || result.lastname
        usuario.value.Apellidos = `${result.lastname1} ${result.lastname2}`
      } else {
        errorMsg.value = 'No se encontraron datos para esta cédula'
      }
    } catch (error) {
      errorMsg.value = 'Error al consultar la API externa'
      console.error(error)
    } finally {
      cargando.value = false // Termina el estado de carga
    }
  }
}

// Función de registro
const registrar = async () => {
  errorMsg.value = ''
  mensaje.value = ''

  if (
    !usuario.value.NombreUsuario ||
    !usuario.value.Apellidos ||
    !usuario.value.Cedula ||
    !usuario.value.Correo ||
    !usuario.value.Telefono
  ) {
    errorMsg.value = 'Por favor complete todos los campos.'
    return
  }

  try {
    const respuesta = await register(usuario.value)
    mensaje.value = respuesta.mensaje

    router.push('/')
  } catch (error) {
    if (error.response && error.response.data && error.response.data.Mensaje) {
      errorMsg.value = error.response.data.Mensaje
    } else {
      errorMsg.value = error.message
    }
    console.error('Error al registrar:', error)
  }
}
</script>

<template>
  <section class="flex flex-col md:flex-row h-screen items-center">
    <div class="hidden lg:block w-full md:w-1/2 xl:w-2/3 h-screen">
      <img
        src="../../assets/img/imgLogin.jpg"
        alt="Imagen bonita"
        class="imagen-transicion h-full w-full object-cover object-center"
      />
    </div>

    <div
      class="bg-[#FAF3E0] w-full md:max-w-md lg:max-w-full md:mx-auto md:mx-0 md:w-1/2 xl:w-1/3 h-screen px-6 lg:px-16 xl:px-12 flex items-center justify-center"
    >
      <div class="w-full h-100 p-8 bg-[#4B2E2E] text-white shadow-2xl rounded-2xl">
        <div
          v-if="errorMsg"
          class="rounded-xl shadow-md mb-4 p-4 bg-red-200 text-red-900"
          role="alert"
        >
          <p class="text-sm font-semibold">{{ errorMsg }}</p>
        </div>
        <!-- Fondo cálido -->
        <h1 class="text-2xl font-bold leading-tight mb-4">Ofrecer voluntariado</h1>

        <form class="space-y-5" @submit.prevent="registrar">
          <div>
            <label class="block text-[#FBE4C8] text-sm font-medium">Cédula</label>
            <input
              v-model="usuario.Cedula"
              type="number"
              placeholder="Ingrese su cédula"
              class="w-full px-4 py-3 rounded-lg bg-[#F3E9DC] text-gray-800 mt-1 border border-[#D6BFA4] focus:border-orange-500 focus:bg-white focus:outline-none"
              required
              @blur="consultarCedula"
            />
          </div>
          <div>
            <label class="block text-[#FBE4C8] text-sm font-medium">Nombre</label>
            <input
              v-model="usuario.NombreUsuario"
              type="text"
              placeholder="Ingrese su nombre"
              class="w-full px-4 py-3 rounded-lg bg-[#F3E9DC] text-gray-800 mt-1 border border-[#D6BFA4] focus:border-orange-500 focus:bg-white focus:outline-none"
              required
              readonly
            />
          </div>

          <div>
            <label class="block text-[#FBE4C8] text-sm font-medium">Apellidos</label>
            <input
              v-model="usuario.Apellidos"
              type="text"
              placeholder="Ingrese sus apellidos"
              class="w-full px-4 py-3 rounded-lg bg-[#F3E9DC] text-gray-800 mt-1 border border-[#D6BFA4] focus:border-orange-500 focus:bg-white focus:outline-none"
              required
              readonly
            />
          </div>

          <div>
            <label class="block text-[#FBE4C8] text-sm font-medium">Correo Electrónico</label>
            <input
              v-model="usuario.Correo"
              type="email"
              placeholder="Ingrese su correo electrónico"
              class="w-full px-4 py-3 rounded-lg bg-[#F3E9DC] text-gray-800 mt-1 border border-[#D6BFA4] focus:border-orange-500 focus:bg-white focus:outline-none"
              required
            />
          </div>
          <div>
            <label class="block text-[#FBE4C8] text-sm font-medium">Numero Telefonico</label>
            <input
              v-model="usuario.Telefono"
              type="number"
              placeholder="Ingrese su numero telefonico"
              class="w-full px-4 py-3 rounded-lg bg-[#F3E9DC] text-gray-800 mt-1 border border-[#D6BFA4] focus:border-orange-500 focus:bg-white focus:outline-none"
              required
            />
          </div>

          <button
            type="submit"
            class="w-full block bg-gradient-to-r from-orange-600 via-orange-400 to-yellow-300 hover:from-orange-500 hover:to-yellow-200 text-[#4B2E2E] font-bold rounded-lg px-4 py-3 mt-6"
          >
            Registrar
          </button>
        </form>

        <hr class="my-6 border-[#D6BFA4]" />

        <p class="mt-6 text-[#FBE4C8] text-sm">
          ¿Ya tienes una cuenta?
          <router-link to="/" class="text-yellow-300 hover:text-yellow-200 font-semibold ml-1">
            Iniciar sesión
          </router-link>
        </p>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
