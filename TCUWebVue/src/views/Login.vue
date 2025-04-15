<script setup>
import { ref } from 'vue'
import loginService from '../services/Login/Login.js'

const usuario = ref({
  username: '',
  password: '',
})

const mensaje = ref('')
const errorMsg = ref('')

const login = async () => {
  try {
    const respuesta = await loginService.login(usuario.value)
    // Si la respuesta es exitosa, mostrar el mensaje
    mensaje.value = 'Usuario logueado correctamente ✅'
    location.href = '/Home'
    console.log('Token:', respuesta.token)
    console.log('Respuesta:', respuesta)
  } catch (error) {
    // En caso de error, mostrar el mensaje de error
    errorMsg.value = 'Hubo un error al loguear el usuario ❌'
    console.error(error)
  }
}
</script>

<template>
  <form @submit.prevent="login">
    <!-- Campos del formulario -->
    <input v-model="usuario.username" placeholder="Nombre usuario" />
    <input v-model="usuario.password" type="password" placeholder="Contraseña" />

    <button type="submit">Loguear</button>

    <!-- Mostrar mensajes -->
    <p v-if="mensaje">{{ mensaje }}</p>
    <p v-if="errorMsg" style="color: red">{{ errorMsg }}</p>
  </form>
</template>
