<template>
  <div class="max-w-screen-xl mx-auto p-5 sm:p-10 md:p-16 bg-gray-50 min-h-screen">
    <h1 class="text-3xl font-extrabold text-center text-indigo-700 mb-10">Usuarios en espera</h1>

    <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
      <!-- Filtro por nombre -->
      <div class="relative w-full sm:w-1/2">
        <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
          <!-- Ícono de lupa -->
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-5 h-5 text-blue-500"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"
            />
          </svg>
        </span>
        <input
          v-model="filtroNombre"
          type="text"
          placeholder="Buscar por nombre..."
          class="border border-gray-300 pl-10 pr-4 py-2 rounded w-full focus:ring-2 focus:ring-blue-400"
        />
      </div>
    </div>

    <div
      v-if="!listaEspera.length || !usuariosEspera.length"
      class="text-center text-gray-600 py-6"
    >
      <p>No hay solicitudes pendientes.</p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-10">
      <div
        v-for="voluntario in usuariosEspera"
        :key="voluntario.id"
        class="rounded-xl overflow-hidden shadow-md hover:shadow-xl transition duration-300 bg-white"
      >
        <div class="px-6 py-4">
          <p class="font-bold text-lg text-indigo-700 mb-2">
            {{ voluntario.nombre }} {{ voluntario.apellidos }}
          </p>
          <ul class="text-gray-600 text-sm space-y-1">
            <li><strong>Correo:</strong> {{ voluntario.correo }}</li>
            <li><strong>Rol:</strong> {{ voluntario.nombreRol }}</li>
            <li><strong>Estado:</strong> {{ voluntario.nombreEstado }}</li>
          </ul>

          <div class="flex justify-end space-x-2 mt-4">
            <button
              @click="abrirModal(voluntario.correo, voluntario.id)"
              class="flex items-center gap-1 bg-green-400 hover:bg-green-600 text-white px-3 py-1 rounded text-sm transition"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652
                 L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1
                 1.13-1.897l8.932-8.931Z"
                />
              </svg>
              Editar Acceso
            </button>

            <modalAccesoUsuarios
              :modalVisible="modalEditarAccesoVisible"
              :correoUsuario="correoSeleccionado"
              :idUsuario="idUsuario"
              @cerrar="modalEditarAccesoVisible = false"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ObtenerUsuariosEspera } from '@/services/UsuariosEspera/UsuariosEsperaService'
const filtroNombre = ref('')
const listaEspera = ref([])
const modalEditarAccesoVisible = ref(false)
import modalAccesoUsuarios from '@/components/UsuariosEspera/modalAccesoUsuarios.vue'
const correoSeleccionado = ref('')
const idUsuario = ref(0)

const usuariosEspera = computed(() =>
  listaEspera.value.filter((v) => {
    const coincideNombre =
      v.nombre.toLowerCase().includes(filtroNombre.value.toLowerCase()) ||
      v.apellidos.toLowerCase().includes(filtroNombre.value.toLowerCase())
    return coincideNombre
  }),
)

const obtenerUsuariosEspera = async () => {
  const resultados = await ObtenerUsuariosEspera()
  listaEspera.value = resultados.map((v) => ({
    id: v.Id_usuario,
    nombre: v.NombreUsuario,
    apellidos: v.Apellidos,
    correo: v.Correo,
    Idrol: v.Id_Rol,
    nombreRol: v.NombreRol,
    nombreEstado: v.NombreEstadoRegistro,
  }))
}

const abrirModal = (correo, id) => {
  idUsuario.value = Number(id)
  correoSeleccionado.value = correo
  modalEditarAccesoVisible.value = true
}
onMounted(() => {
  obtenerUsuariosEspera()
})
</script>
