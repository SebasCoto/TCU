<template>
  <div
    v-if="modalVisible"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
  >
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md p-6">
      <div class="flex justify-between items-center border-b pb-3">
        <h3 class="text-lg font-semibold text-gray-800">Editar Producto</h3>
        <button @click="cerrarModal" class="text-gray-500 hover:text-gray-800">✕</button>
      </div>

      <!-- Mensaje de error -->
      <div v-if="errorMsg" class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">
        {{ errorMsg }}
      </div>

      <form @submit.prevent="guardarCambios" class="mt-4 space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Nombre producto</label>
          <input
            v-model="nombreProducto"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Escribe un mensaje para el usuario..."
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Stock</label>
          <input
            v-model="Stock"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Escribe un mensaje para el usuario..."
          />
        </div>
        <div>
          <label for="categoria" class="block text-sm font-medium text-gray-700">Categoría</label>
          <select
            id="categoria"
            v-model="categoriaSeleccionada"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          >
            <option disabled value="">Seleccione una categoría</option>
            <option v-for="categoria in categorias" :key="categoria.id" :value="categoria.id">
              {{ categoria.nombre }}
            </option>
          </select>
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
import { ref, watch } from 'vue'
import {
  obtenerCategorias,
  obtenerProductosById,
  actualizarProducto,
} from '@/services/Inventario/InventarioService'

export default {
  name: 'EditarAccesoModal',
  props: {
    modalVisible: {
      type: Boolean,
      required: true,
    },
    idProducto: {
      type: Number,
      required: true,
    },
  },
  setup(props, { emit }) {
    const categorias = ref([])
    const categoriaSeleccionada = ref('')
    const errorMsg = ref('')
    const loading = ref(false)
    const nombreProducto = ref('')
    const Stock = ref('')

    const cerrarModal = () => {
      errorMsg.value = ''
      emit('cerrar')
    }

    const cargarCategorias = async () => {
      loading.value = true
      errorMsg.value = ''
      try {
        const resultados = await obtenerCategorias()
        if (resultados && Array.isArray(resultados.Datos)) {
          categorias.value = resultados.Datos.map((v) => ({
            id: v.id_categoria,
            nombre: v.nombre,
          }))
        } else {
          throw new Error('Error: Datos no es un array válido')
        }
      } catch (error) {
        console.error('Error al cargar categorías:', error)
        errorMsg.value = 'Error al cargar categorías.'
      } finally {
        loading.value = false
      }
    }

    const guardarCambios = async () => {
      errorMsg.value = ''
      try {
        const datos = {
          Id_Inventario: props.idProducto,
          nombreProducto: nombreProducto.value,
          Stock: Stock.value,
          id_categoria: categoriaSeleccionada.value,
        }

        loading.value = true
        await actualizarProducto(datos)
        cerrarModal()
        location.reload()
      } catch (error) {
        console.error('Error al guardar producto:', error)
        errorMsg.value = error.message
      } finally {
        loading.value = false
      }
    }

    const cargarProducto = async () => {
      errorMsg.value = ''
      try {
        const datos = await obtenerProductosById(props.idProducto)
        if (datos?.Datos?.length) {
          const producto = datos.Datos[0]
          nombreProducto.value = producto.NombreProducto
          Stock.value = producto.stock
          categoriaSeleccionada.value = producto.Id_Categoria
        } else {
          throw new Error('Producto no encontrado')
        }
      } catch (error) {
        console.error('Error al cargar producto:', error)
        errorMsg.value = 'Error al cargar los datos del producto.'
      }
    }

    watch(
      () => props.modalVisible,
      async (nuevoValor) => {
        if (nuevoValor) {
          await cargarCategorias()
          await cargarProducto()
        }
      },
    )

    return {
      categorias,
      categoriaSeleccionada,
      loading,
      cerrarModal,
      guardarCambios,
      nombreProducto,
      Stock,
      errorMsg,
    }
  },
}
</script>
