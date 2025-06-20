<template>
  <div class="p-6 bg-white rounded-xl">
    <!-- Título -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-3xl font-bold text-indigo-700">Agregar Producto</h2>
    </div>
    <div v-if="errorMsg" class="rounded-xl shadow-md mb-4 p-4 bg-red-200 text-red-900" role="alert">
      <p class="text-sm font-semibold">{{ errorMsg }}</p>
    </div>
    <!-- Formulario -->
    <form @submit.prevent="guardarProducto" class="space-y-6">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Nombre -->
        <div>
          <label for="ProductName" class="block text-sm font-medium text-gray-700"
            >Nombre del producto</label
          >
          <input
            v-model="ProductoData.NombreProducto"
            id="ProductName"
            type="text"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          />
        </div>

        <div>
          <label for="stock" class="block text-sm font-medium text-gray-700"
            >Cantidad disponible</label
          >
          <input
            v-model="ProductoData.stock"
            id="stock"
            type="number"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
            placeholder=""
          />
        </div>
        <div>
          <label for="categoria" class="block text-sm font-medium text-gray-700">Categoria</label>
          <select
            id="categoria"
            v-model="ProductoData.id_categoria"
            class="w-full mt-1 p-3 border border-gray-300 rounded-lg"
          >
            <option disabled value="">Seleccione una categoria</option>
            <option v-for="categoria in categorias" :key="categoria.id" :value="categoria.id">
              {{ categoria.nombre }}
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
          to="/obtenerInventario"
          class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-6 rounded-lg transition shadow-md"
        >
          Cancelar
        </router-link>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { agregarProducto, obtenerCategorias } from '@/services/Inventario/InventarioService'
import router from '@/router'
const categorias = ref([])
const loading = ref(false)

const ProductoData = ref({
  NombreProducto: '',
  id_categoria: '',
  stock: '',
})

const errorMsg = ref('')
const mensaje = ref('')

const cargarCategorias = async () => {
  loading.value = true
  try {
    const resultados = await obtenerCategorias()

    if (resultados && Array.isArray(resultados.Datos)) {
      categorias.value = resultados.Datos.map((v) => ({
        id: v.id_categoria,
        nombre: v.nombre,
      }))
    } else {
      console.error('Error: Datos no es un array', resultados)
      categorias.value = []
    }
  } catch (error) {
    console.error('Error al cargar categorias:', error)
    categorias.value = []
  } finally {
    loading.value = false
  }
}

const guardarProducto = async () => {
  errorMsg.value = ''
  mensaje.value = ''

  if (
    !ProductoData.value.NombreProducto ||
    !ProductoData.value.id_categoria ||
    !ProductoData.value.stock
  ) {
    errorMsg.value = 'Por favor complete todos los campos.'
    return
  }

  try {
    const respuesta = await agregarProducto(ProductoData.value)
    mensaje.value = respuesta.mensaje
    router.push('/ObtenerInventario')
  } catch (error) {
    if (error.response && error.response.data && error.response.data.Mensaje) {
      errorMsg.value = error.response.data.Mensaje
    } else {
      errorMsg.value = error.message
    }
    console.error('Error al registrar:', error)
  }
}

onMounted(async () => {
  await cargarCategorias()
})
</script>
