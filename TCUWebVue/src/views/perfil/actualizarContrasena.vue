<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { cambiarContrasena } from '@/services/perfil/perfilServices'
import Swal from 'sweetalert2'
import { useLoginStore } from '@/stores/Login/LoginStore'

const router = useRouter()
const loginStore = useLoginStore()

const showCurrent = ref(false)
const showNew = ref(false)
const showConfirm = ref(false)

const mensaje = ref('')
const errorMsg = ref('')
const infoMsg = ref('')

const data = ref({
  OldPassword: '',
  Password: '',
  confirmPassword: '',
})

const loading = ref(false)

// Mostrar mensaje si la contraseña es temporal
if (loginStore.passwordExp === true) {
  infoMsg.value =
    'Estás aquí porque tu contraseña es temporal. Por favor, actualízala para continuar usando la plataforma.'
}

const actualizarContrasena = async () => {
  loading.value = true
  if (!data.value.OldPassword || !data.value.Password || !data.value.confirmPassword) {
    errorMsg.value = 'Por favor, completa todos los campos'
    mensaje.value = ''
    loading.value = false
    return
  }

  Swal.fire({
    title: '¿Está seguro de que desea cambiar la contraseña?',
    text: 'Una vez cambiada no podrá volver a usar la contraseña anterior',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Sí, cambiarla!',
  }).then(async (result) => {
    if (result.isConfirmed) {
      try {
        const response = await cambiarContrasena(data.value)

        mensaje.value = response.mensaje
        errorMsg.value = ''
        Swal.fire({
          icon: 'success',
          title: '¡Éxito!',
          text: mensaje.value,
          confirmButtonText: 'Aceptar',
        }).then(() => {
          data.value = {
            OldPassword: '',
            Password: '',
            confirmPassword: '',
          }
          loginStore.passwordExp = false
          router.push('/perfil')
        })
        mensaje.value = ''
      } catch (error) {
        console.error('Error al actualizar la contraseña:', error)
        errorMsg.value = error.message
        mensaje.value = ''
      } finally {
        loading.value = false
      }
    } else {
      loading.value = false
    }
  })
}
</script>

<template>
  <!-- Título -->
  <div class="mb-8 text-center">
    <h2 class="text-3xl font-bold text-gray-800">Actualizar Contraseña</h2>
    <p class="text-gray-500 mt-1">Por favor, completa todos los campos</p>
  </div>

  <!-- Mensaje informativo -->
  <div v-if="infoMsg" class="mb-4 p-3 bg-blue-100 text-blue-800 rounded-lg border border-blue-300">
    {{ infoMsg }}
  </div>

  <!-- Mensaje de error -->
  <div v-if="errorMsg" class="mb-4 p-3 bg-red-100 text-red-800 rounded-lg border border-red-300">
    {{ errorMsg }}
  </div>

  <!-- Formulario -->
  <form class="space-y-6" @submit.prevent="actualizarContrasena">
    <!-- Contraseña actual -->
    <div>
      <label class="block text-sm font-medium text-gray-700 mb-1">Contraseña actual</label>
      <div class="relative">
        <input
          :type="showCurrent ? 'text' : 'password'"
          v-model="data.OldPassword"
          class="w-full p-3 pr-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Ingresa tu contraseña actual"
        />
        <button
          type="button"
          @click="showCurrent = !showCurrent"
          class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
        >
          <!-- Iconos -->
        </button>
      </div>
    </div>

    <!-- Nueva contraseña -->
    <div>
      <label class="block text-sm font-medium text-gray-700 mb-1">Nueva contraseña</label>
      <div class="relative">
        <input
          :type="showNew ? 'text' : 'password'"
          v-model="data.Password"
          class="w-full p-3 pr-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Ingresa la nueva contraseña"
        />
        <button
          type="button"
          @click="showNew = !showNew"
          class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
        >
          <!-- Iconos -->
        </button>
      </div>
    </div>

    <!-- Confirmar contraseña -->
    <div>
      <label class="block text-sm font-medium text-gray-700 mb-1">Confirmar contraseña</label>
      <div class="relative">
        <input
          :type="showConfirm ? 'text' : 'password'"
          v-model="data.confirmPassword"
          class="w-full p-3 pr-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Confirma la nueva contraseña"
        />
        <button
          type="button"
          @click="showConfirm = !showConfirm"
          class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
        >
          <!-- Iconos -->
        </button>
      </div>
    </div>

    <!-- Botones -->
    <div class="flex flex-col sm:flex-row gap-4 justify-center mt-6">
      <button
        type="submit"
        class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg transition shadow-md"
      >
        Guardar Cambios
      </button>

      <router-link
        to="/perfil"
        class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-6 rounded-lg transition shadow-md text-center"
      >
        Cancelar
      </router-link>
    </div>
  </form>
</template>
