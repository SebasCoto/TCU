<script setup>
import { ref } from 'vue'

import { recuperarAcceso } from '@/services/Login/Login'

const Correo = ref('')

const mensaje = ref('')
const errorMsg = ref('')

const recuperar = async () => {
  errorMsg.value = ''
  mensaje.value = ''

  try {
    const respuesta = await recuperarAcceso({ Correo: Correo.value })
    mensaje.value = respuesta.Mensaje
  } catch (error) {
    errorMsg.value = error.message
    console.error('Error al recuperar acceso:', error)
  }
}
</script>

<template>
  <section class="flex flex-col md:flex-row h-screen items-center">
    <div class="hidden lg:block w-full md:w-1/2 xl:w-2/3 h-screen">
      <img
        src="../../assets/img/imgLogin.jpg"
        alt="Fondo de atardecer"
        class="w-full h-full object-cover"
      />
    </div>

    <div
      class="bg-[#FAF3E0] w-full md:max-w-md lg:max-w-full md:mx-auto md:mx-0 md:w-1/2 xl:w-1/3 h-screen px-6 lg:px-16 xl:px-12 flex items-center justify-center"
    >
      <div class="w-full h-100 p-8 bg-[#4B2E2E] text-white shadow-2xl rounded-2xl">
        <div class="w-full h-100">
          <div
            v-if="errorMsg"
            class="rounded-xl shadow-md mb-4 p-4 bg-red-200 text-red-900"
            role="alert"
          >
            <p class="text-sm font-semibold">{{ errorMsg }}</p>
          </div>

          <h1 class="text-2xl font-bold leading-tight mb-4">Recuperar Acceso</h1>

          <form @submit.prevent="recuperar" class="space-y-5">
            <div>
              <label class="block text-[#FBE4C8] text-sm font-medium">Correo Electrónico</label>
              <input
                v-model="Correo"
                type="email"
                placeholder="Ingrese su correo electrónico"
                class="w-full px-4 py-3 rounded-lg bg-[#F3E9DC] text-gray-800 mt-1 border border-[#D6BFA4] focus:border-orange-500 focus:bg-white focus:outline-none"
                required
              />
            </div>

            <button
              type="submit"
              class="w-full block bg-gradient-to-r from-orange-600 via-orange-400 to-yellow-300 hover:from-orange-500 hover:to-yellow-200 text-[#4B2E2E] font-bold rounded-lg px-4 py-3 mt-6"
            >
              Recuperar acceso
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
    </div>
  </section>
</template>
