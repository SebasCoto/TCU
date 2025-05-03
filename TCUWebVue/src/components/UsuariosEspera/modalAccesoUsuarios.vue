<template>
  <div
    v-if="modalVisible"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
  >
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md p-6">
      <div class="flex justify-between items-center border-b pb-3">
        <h3 class="text-lg font-semibold text-gray-800">Editar acceso del usuario</h3>
        <button @click="cerrarModal" class="text-gray-500 hover:text-gray-800">✕</button>
      </div>

      <form @submit.prevent="guardarCambios" class="mt-4 space-y-4">
        <input type="hidden" :value="correoUsuario" name="correo" />

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Estado de acceso</label>
          <select
            v-model="estadoSeleccionado"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          >
            <option disabled value="">Seleccione un estado</option>
            <option v-for="estado in estados" :key="estado.id" :value="estado.id">
              {{ estado.nombre }}
            </option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Mensaje (opcional)</label>
          <textarea
            v-model="mensaje"
            rows="3"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
            placeholder="Escribe un mensaje para el usuario..."
          ></textarea>
        </div>

        <div class="flex justify-end space-x-2 pt-4 border-t">
          <button
            type="button"
            @click="cerrarModal"
            class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 hover:bg-gray-300 transition"
          >
            Cancelar
          </button>
          <button
            type="submit"
            class="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700 transition"
          >
            Guardar cambios
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { ObtenerEstados, AccesoUsuarios } from '@/services/UsuariosEspera/UsuariosEsperaService'

export default {
  name: 'EditarAccesoModal',
  props: {
    modalVisible: {
      type: Boolean,
      required: true,
    },
    correoUsuario: {
      type: String,
      required: true,
    },
    idUsuario: {
      type: Number,
      required: true,
    },
  },
  setup(props, { emit }) {
    const estados = ref([])
    const estadoSeleccionado = ref('')
    const mensaje = ref('')
    const loading = ref(false)

    const cerrarModal = () => {
      emit('cerrar')
    }

    const cargarEstados = async () => {
      loading.value = true
      try {
        const resultados = await ObtenerEstados()
        estados.value = resultados.map((estado) => ({
          id: estado.id_estadoRegistro,
          nombre: estado.nombre,
        }))
      } catch (error) {
        console.error('Error al cargar estados:', error)
      } finally {
        loading.value = false
      }
    }

    const guardarCambios = async () => {
      try {
        const datos = {
          correo: props.correoUsuario,
          id_EstadoRegistro: estadoSeleccionado.value,
          mensaje: mensaje.value,
          id_usuario: props.idUsuario,
        }
        console.log(estadoSeleccionado)
        loading.value = true
        await AccesoUsuarios(datos)
        console.log('Datos guardados exitosamente:', datos)
        cerrarModal()
      } catch (error) {
        console.error('Error al guardar los cambios:', error)
      } finally {
        loading.value = false
      }
    }

    onMounted(() => {
      cargarEstados()
    })

    return {
      estados,
      estadoSeleccionado,
      mensaje,
      loading,
      cerrarModal,
      guardarCambios,
    }
  },
}
</script>
