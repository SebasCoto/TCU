<script setup>
import FullCalendar from '@fullcalendar/vue3'
import CrearEventoModal from '@/components/Calendario/CrearEventoModal.vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { ref, onMounted } from 'vue'
import Swal from 'sweetalert2'
import { useLoginStore } from '@/stores/Login/LoginStore'
import { obtenerEventos, obtenerEventosPorId } from '@/services/Calendario/CalendarioService.js'
import EditarEventoModal from '@/components/Calendario/EditarEventoModal.vue'
const modalCrearVisible = ref(false)
const modalEditarVisible = ref(false)
const eventoSeleccionado = ref({ title: '', description: '', start: '', end: '', color: '' })

function formatearFecha(fecha) {
  if (!fecha) return ''
  const d = new Date(fecha)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

const calendarOptions = ref({
  plugins: [dayGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth',
  contentHeight: '900px',
  aspectRatio: 1.5,
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,dayGridWeek,dayGridDay',
  },
  selectable: false,
  editable: false,
  dateClick: function (info) {
    console.log('Fecha seleccionada:', info.dateStr) // Verificar la fecha seleccionada

    const loginStore = useLoginStore()
    if (loginStore.NombreRol === 'Voluntario') {
      Swal.fire({
        title: '¡Hola!',
        text: 'No tienes permisos para crear eventos.',
        icon: 'warning',
        confirmButtonText: 'Aceptar',
      })
      return
    }

    const fechaSeleccionada = new Date(info.dateStr)
    const fechaActual = new Date()
    fechaActual.setHours(0, 0, 0, 0)

    if (fechaSeleccionada < fechaActual) {
      Swal.fire({
        title: '¡Error!',
        text: 'No puedes seleccionar una fecha pasada.',
        icon: 'error',
      })
      return
    }

    console.log('Fecha futura seleccionada:', info.dateStr) // Verificar si la fecha futura está siendo seleccionada

    // Aquí asignamos la fecha y otros datos al evento
    eventoSeleccionado.value = {
      title: '',
      description: '',
      start: info.dateStr,
      end: info.dateStr,
      color: '#ffffff',
    }
    eventoSeleccionado.value = info.event
    modalCrearVisible.value = true // Abrir el modal de detalles

    console.log('Modal abierto:', modalCrearVisible.value) // Verificar si el modal se abre
  },
  events: [],
  eventClick: function (info) {
    console.log('Evento seleccionado:', info.event) // Verificar el evento seleccionado
    eventoSeleccionado.value = {
      title: info.event.title || '',
      description: info.event.extendedProps?.description || '',
      start: formatearFecha(info.event.start),
      end: formatearFecha(info.event.end),
      color: info.event.backgroundColor || '#ffffff',
    }

    obtenerEventoById(info.event.id).then((evento) => {
      console.log('Evento obtenido por ID:', evento) // Verificar el evento obtenido por ID
      eventoSeleccionado.value = {
        id: evento.Id_Evento,
        title: evento.Nombre_Evento,
        description: evento.Descripcion,
        start: formatearFecha(evento.Fecha_Inicio),
        end: formatearFecha(evento.Fecha_Final),
        color: evento.Color,
      }
      modalEditarVisible.value = true // Mostrar el modal solo después de que los datos estén listos
      console.log('Modal editar visible:', modalEditarVisible.value)
    })
  },
})

const mostrarEventos = async () => {
  try {
    const eventos = await obtenerEventos()

    if (!Array.isArray(eventos)) {
      console.warn('El resultado de obtenerEventos no es un array:', eventos)
      return []
    }
    return eventos
  } catch (error) {
    console.error('Error al obtener eventos:', error)
    return []
  }
}

const obtenerEventoById = async (id) => {
  try {
    const evento = await obtenerEventosPorId(id)
    eventoSeleccionado.value = {
      id: evento.id,
      title: evento.Nombre_Evento,
      description: evento.Descripcion,
      start: evento.Fecha_Inicio,
      end: evento.Fecha_Final,
      color: evento.Color,
    }
    return evento
  } catch (error) {
    console.error('Error al obtener evento por ID:', error)
    return null
  }
}

onMounted(async () => {
  const eventos = await mostrarEventos()
  calendarOptions.value.events = eventos
})

const actualizarEvento = (eventoActualizado) => {
  console.log('Evento actualizado:', eventoActualizado)
  // Aquí puedes agregar la lógica para actualizar el evento en tu backend o estado local
}
</script>

<template>
  <div class="home-wrapper">
    <FullCalendar style="height: 100%; max-height: 100%" v-bind:options="calendarOptions" />

    <!-- Modal de creación de evento -->
    <CrearEventoModal :modalVisible="modalCrearVisible" @cerrar="modalCrearVisible = false" />
    <EditarEventoModal
      :modalVisible="modalEditarVisible"
      :eventoSeleccionado="eventoSeleccionado"
      @guardar-cambios="actualizarEvento"
      @cerrar="modalEditarVisible = false"
    />
  </div>
</template>

<style scoped>
.home-wrapper {
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}
</style>
