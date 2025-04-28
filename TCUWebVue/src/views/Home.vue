<script setup>
import FullCalendar from '@fullcalendar/vue3'
import CrearEventoModal from '@/components/Calendario/CrearEventoModal.vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { ref } from 'vue'
import Swal from 'sweetalert2'
import { useLoginStore } from '@/stores/Login/LoginStore'

const modalCrearVisible = ref(false)
const eventoSeleccionado = ref({ title: '', description: '', start: '', end: '', color: '' })

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
  selectable: true,
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

    // Abrir el modal de creación de evento
    modalCrearVisible.value = true
    console.log('Modal abierto:', modalCrearVisible.value) // Verificar si el modal se abre
  },
  eventClick: function (info) {
    eventoSeleccionado.value = info.event
    modalCrearVisible.value = true // Abrir el modal de detalles
  },
  events: [
    { title: 'event 1', date: '2025-04-01' },
    { title: 'event 2', date: '2025-04-02' },
  ],
})
</script>

<template>
  <div class="home-wrapper">
    <FullCalendar style="height: 100%; max-height: 100%" v-bind:options="calendarOptions" />

    <!-- Modal de creación de evento -->
    <CrearEventoModal :modalVisible="modalCrearVisible" @cerrar="modalCrearVisible = false" />
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
