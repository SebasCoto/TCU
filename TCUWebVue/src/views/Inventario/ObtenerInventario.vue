<template>
  <div
    class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 bg-white rounded-2xl border border-gray-300"
  >
    <!-- Encabezado -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
      <h2 class="text-3xl sm:text-4xl font-semibold text-gray-800">Lista de Productos</h2>

      <div class="flex flex-wrap gap-4">
        <router-link
          to="/agregarProducto"
          class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg transition-all duration-300 shadow-lg hover:shadow-xl text-sm md:text-base"
        >
          Agregar Producto
        </router-link>
      </div>
    </div>

    <!-- Filtros de búsqueda -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
      <!-- Buscar por nombre -->
      <div class="relative">
        <InputText
          v-model="searchQuery"
          placeholder="🔍 Buscar producto..."
          class="w-full px-6 py-3 rounded-xl border border-gray-300 shadow-sm bg-white text-gray-700 focus:ring-2 focus:ring-blue-500 focus:outline-none transition-all"
        />
        <span
          class="absolute top-3 right-4 text-gray-400 hover:text-red-500 cursor-pointer transition-all"
          @click="searchQuery = ''"
        >
          <i class="pi pi-times"></i>
        </span>
      </div>

      <!-- Filtro por categoría -->
      <div>
        <select
          v-model="selectedCategory"
          class="w-full px-6 py-3 rounded-xl border border-gray-300 shadow-sm bg-white text-gray-700 focus:ring-2 focus:ring-blue-500 focus:outline-none transition-all"
        >
          <option value="">Todas las categorías</option>
          <option v-for="cat in categorias" :key="cat.id" :value="cat.id">
            {{ cat.nombre }}
          </option>
        </select>
      </div>
    </div>

    <div class="overflow-x-auto bg-white">
      <DataTable
        showGridlines
        v-if="filteredProductos.length > 0"
        :value="paginatedProductos"
        class="min-w-[600px] w-full text-sm md:text-base"
        :rowClass="(row, index) => (index % 2 === 0 ? 'bg-gray-50' : 'bg-white')"
      >
        <Column field="NombreProducto" header="Nombre">
          <template #header>
            <span class="flex items-center gap-2 text-gray-700 font-semibold">
              <i class="pi pi-box text-blue-500"></i>
            </span>
          </template>
        </Column>
        <Column field="NombreCategoria" header="Categoría">
          <template #header>
            <span class="flex items-center gap-2 text-gray-700 font-semibold">
              <i class="pi pi-tags text-pink-500"></i>
            </span>
          </template>
        </Column>
        <Column field="stock" header="Stock">
          <template #header>
            <span class="flex items-center gap-2 text-gray-700 font-semibold">
              <i class="pi pi-list text-green-500"></i>
            </span>
          </template>
        </Column>
        <Column style="width: auto">
          <template #header>
            <div class="w-full text-center text-gray-700 font-semibold">Acciones</div>
          </template>
          <template #body="slotProps">
            <div class="flex gap-2 justify-center">
              <!-- Botón Editar -->
              <Button
                label="Editar"
                icon="pi pi-pencil"
                class="!bg-yellow-500 hover:!bg-yellow-600 text-white px-4 py-2 rounded-lg transition-all duration-300 shadow-lg hover:shadow-xl text-sm"
                @click="
                  abrirModal(slotProps.data.id, slotProps.data.id_categoria, slotProps.data.stock)
                "
              />

              <!-- Botón Eliminar -->
              <Button
                label="Eliminar"
                icon="pi pi-trash"
                class="!bg-red-500 hover:!bg-red-600 text-white px-4 py-2 rounded-lg transition-all duration-300 shadow-lg hover:shadow-xl text-sm"
                @click="EliminarProducto(slotProps.data.id)"
              />
            </div>
          </template>
        </Column>
      </DataTable>

      <!-- Mensaje cuando no hay productos -->
      <div v-else class="text-center text-gray-500 p-6">
        <p>No se encontraron productos.</p>
      </div>

      <div class="mt-6">
        <Paginator
          v-if="filteredProductos.length >= 9"
          v-model:first="first"
          v-model:rows="rows"
          :totalRecords="filteredProductos.length"
          template="FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink RowsPerPageDropdown"
          currentPageReportTemplate="Mostrando {first} a {last} de {totalRecords} productos"
          class="bg-white text-gray-800 rounded-xl p-4 border border-gray-300 shadow-md"
        />
      </div>
    </div>
    <EditarProductoModal
      :modalVisible="modalEditarProductoVisible"
      :idProducto="idProducto"
      @cerrar="modalEditarProductoVisible = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import Button from 'primevue/button'
import InputText from 'primevue/inputtext'
import Paginator from 'primevue/paginator'
import {
  obtenerProductos,
  obtenerCategorias,
  eliminarProducto,
} from '@/services/Inventario/InventarioService'
import EditarProductoModal from '@/components/Inventario/EditarProductoModal.vue'
import Swal from 'sweetalert2'
const ProductoData = ref([])
const searchQuery = ref('')
const selectedCategory = ref('')
const categorias = ref([])
const first = ref(0)
const rows = ref(10)
const modalEditarProductoVisible = ref(false)
const loading = ref(false)
const idProducto = ref(0)

const EliminarProducto = async (id) => {
  Swal.fire({
    title: '¿Está seguro de que desea eliminar el producto?',
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
        await eliminarProducto(id)

        Swal.fire({
          icon: 'success',
          title: 'Producto eliminado!',
          text: 'El Producto ha sido eliminado exitosamente.',
          timer: 1000,
          showConfirmButton: false,
          timerProgressBar: true,
          didClose: () => {
            location.reload()
          },
        })
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text:
            error.response?.data?.detalle ||
            'Ocurrió un error al eliminar el Producto. Por favor, inténtelo de nuevo.',
          confirmButtonText: 'Aceptar',
        })
      }
    }
  })
}

const mostrarProductos = async () => {
  try {
    const response = await obtenerProductos()
    if (!response || !Array.isArray(response.Datos)) {
      console.error('Error: La respuesta no es un array válido')
      return
    }
    ProductoData.value = response.Datos.map((p) => ({
      id: p.Id_Inventario,
      NombreProducto: p.NombreProducto,
      stock: p.stock,
      NombreCategoria: p.NombreCategoria,
      id_categoria: p.Id_Categoria,
    }))
  } catch (err) {
    console.error('Error al obtener productos:', err)
  }
}
const abrirModal = (id) => {
  idProducto.value = Number(id)
  modalEditarProductoVisible.value = true
}
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

const filteredProductos = computed(() =>
  ProductoData.value.filter((p) => {
    const matchNombre = p.NombreProducto.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchCategoria =
      selectedCategory.value === '' || p.id_categoria === selectedCategory.value
    return matchNombre && matchCategoria
  }),
)

const paginatedProductos = computed(() => {
  const start = first.value
  const end = first.value + rows.value
  return filteredProductos.value.slice(start, end)
})

onMounted(() => {
  mostrarProductos()
  cargarCategorias()
})
</script>
