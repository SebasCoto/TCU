import { ref, watch } from 'vue'
import Multiselect from 'vue-multiselect'
import {
  obtenerCorreos,
  guardarEvento as guardarEventoService,
} from '@/services/Calendario/CalendarioService.js'
import Swal from 'sweetalert2'

export default {
  name: 'CrearEventoModal',
  components: {
    Multiselect,
  },
  props: {
    modalVisible: Boolean,
    fechaSeleccionada: String,
  },
  emits: ['cerrar'],
  setup(props, { emit }) {
    const correos = ref([])
    const selectedCorreos = ref([])
    const loading = ref(false)
    const mensaje = ref('')
    const errorMsg = ref('')

    const evento = ref({
      titulo: '',
      descripcion: '',
      fechaInicio: props.fechaSeleccionada || '',
      fechaFinal: props.fechaSeleccionada || '',
      color: '#ffffff',
    })

    const cargarCorreos = async () => {
      loading.value = true
      try {
        const resultados = await obtenerCorreos('')
        correos.value = resultados.map((correo) => ({
          id: correo.id,
          text: correo.text,
        }))
      } catch (error) {
        console.error('Error al cargar correos:', error)
      } finally {
        loading.value = false
      }
    }

    const buscarCorreos = async (query) => {
      if (!query) return
      loading.value = true
      try {
        const resultados = await obtenerCorreos(query)
        correos.value = resultados.map((correo) => ({
          id: correo.id,
          text: correo.text,
        }))
      } catch (error) {
        console.error('Error al buscar correos:', error)
      } finally {
        loading.value = false
      }
    }

    // Watch para cuando cambie la fecha seleccionada
    watch(
      () => props.fechaSeleccionada,
      (nuevaFecha) => {
        if (nuevaFecha) {
          evento.value.fechaInicio = nuevaFecha
          evento.value.fechaFinal = nuevaFecha
        }
      },
      { immediate: true },
    )

    watch(
      () => props.modalVisible,
      (nuevoValor) => {
        if (nuevoValor) {
          // Usar la fecha seleccionada o la fecha actual como fallback
          const fecha = props.fechaSeleccionada
          if (fecha) {
            evento.value.fechaInicio = fecha
            evento.value.fechaFinal = fecha
          }
          cargarCorreos() // Solo cargar correos cuando el modal esté abierto
        } else {
          correos.value = [] // Limpia los datos si es necesario
          selectedCorreos.value = []
          errorMsg.value = ''
          mensaje.value = ''
        }
      },
    )

    const guardarEvento = async () => {
      const eventoData = {
        Nombre_Evento: evento.value.titulo,
        Descripcion: evento.value.descripcion,
        Fecha_Inicio: evento.value.fechaInicio,
        Fecha_Final: evento.value.fechaFinal,
        Color: evento.value.color,
        Invitados: selectedCorreos.value.map((correo) => correo.id).join(','), // Convertir a cadena separada por comas
      }

      errorMsg.value = ''
      mensaje.value = ''

      Swal.fire({
        title: 'Cargando...',
        text: 'Por favor, espere un momento.',
        allowOutsideClick: false,
        didOpen: () => {
          Swal.showLoading()
        },
      })

      try {
        const respuesta = await guardarEventoService(eventoData)
        mensaje.value = respuesta.Mensaje
        Swal.fire({
          icon: 'success',
          title: 'Evento agregado correctamente',
        })
        emit('evento-actualizado')
        cerrarModal()
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        errorMsg.value = error.response?.data?.detalle || error.message
        console.error('Error al guardar evento:', error)
      }
    }

    const cerrarModal = () => {
      emit('cerrar')
    }

    return {
      correos,
      selectedCorreos,
      loading,
      buscarCorreos,
      guardarEvento,
      cerrarModal,
      mensaje,
      errorMsg,
      evento,
    }
  },
}
