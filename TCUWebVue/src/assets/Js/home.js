import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { ref } from 'vue'
import Swal from 'sweetalert2'
import { useLoginStore } from '@/stores/Login/LoginStore'
import { obtenerEventos, obtenerEventosPorId } from '@/services/Calendario/CalendarioService.js'
const modalCrearVisible = ref(false)
const modalEditarVisible = ref(false)
const modalDetalleVisible = ref(false)

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
      end: info.event.end ? formatearFecha(info.event.end) : 'No disponible', // Validar el valor de end
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
    })

    const loginStore = useLoginStore()
    if (loginStore.NombreRol === 'Voluntario') {
      // Mostrar el modal de detalles para voluntarios
      modalDetalleVisible.value = true
      return
    }
    if (loginStore.NombreRol === 'Administrador') {
      // Mostrar el modal de detalles para voluntarios
      modalEditarVisible.value = true
      return
    }
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

const refrescarEventos = async () => {
  console.log('Refrescando eventos...')
  const eventos = await mostrarEventos()
  calendarOptions.value = {
    ...calendarOptions.value,
    events: [...eventos], // Crear una nueva referencia al array de eventos
  }
  console.log('Eventos actualizados:', eventos)
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
export {
  modalCrearVisible,
  modalEditarVisible,
  modalDetalleVisible,
  eventoSeleccionado,
  calendarOptions,
  refrescarEventos,
}
