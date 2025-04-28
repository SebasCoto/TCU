import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { ref } from 'vue'
import { useLoginStore } from '@/stores/Login/LoginStore'
import Swal from 'sweetalert2'

export const modalCrearVisible = ref(false)
export const modalEditarVisible = ref(false)
export const modalDetallesVisible = ref(false)
export const eventoSeleccionado = ref(null)
export const isButtonDisabled = ref(false)

const calendarOptions = ref({
  plugins: [dayGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth',
  contentHeight: '900px',
  aspectRatio: 1.5,
  initialView: 'dayGridMonth',
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,dayGridWeek,dayGridDay',
  },
  selectable: true,
  editable: false,
  dateClick: function (info) {
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
      calendarOptions.value.isButtonDisabled = true
    } else {
      calendarOptions.value.isButtonDisabled = false
    }
  },
  events: [
    { title: 'event 1', date: '2025-04-01' },
    { title: 'event 2', date: '2025-04-02' },
  ],
  isButtonDisabled: false,
})

export default calendarOptions
