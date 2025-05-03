import { ref, watch } from 'vue'
import { EditarEvento, EliminarEvento } from '@/services/Calendario/CalendarioService'

export default {
  name: 'EditarEventoModal',
  props: {
    modalVisible: Boolean,
    eventoSeleccionado: Object,
  },
  setup(props, { emit }) {
    const evento = ref({ ...props.eventoSeleccionado })
    const mensaje = ref('') // Declaración de mensaje
    const errorMsg = ref('') // Declaración de errorMsg
    watch(
      () => props.eventoSeleccionado,
      (nuevoValor) => {
        evento.value = {
          ...nuevoValor,
        }
      },
      { immediate: true },
    )

    const actualizarEvento = async () => {
      console.log('Evento a guardar:', evento.value)
      const eventoData = {
        Id_Evento: evento.value.id,
        Nombre_Evento: evento.value.title,
        Descripcion: evento.value.description,
        Fecha_Inicio: evento.value.start,
        Fecha_Final: evento.value.end,
      }

      errorMsg.value = ''
      mensaje.value = ''

      // Verificar si no hubo cambios
      if (
        evento.value.title === props.eventoSeleccionado.title &&
        evento.value.description === props.eventoSeleccionado.description &&
        evento.value.start === props.eventoSeleccionado.start &&
        evento.value.end === props.eventoSeleccionado.end
      ) {
        errorMsg.value = 'No se realizaron cambios en el evento.'
        return
      }

      try {
        const respuesta = await EditarEvento(eventoData)
        mensaje.value = respuesta.Mensaje
        emit('evento-actualizado')
        cerrarModal()
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        errorMsg.value =
          error.response?.data?.detalle ||
          'Ocurrió un error al guardar el evento. Por favor, inténtelo de nuevo.'
        console.error('Error al guardar evento:', error)
      }

      emit('guardar-cambios', eventoData)
    }

    const deleteEvent = async () => {
      errorMsg.value = ''
      mensaje.value = ''
      try {
        await EliminarEvento(evento.value.id)
        mensaje.value = 'Evento eliminado correctamente'
        console.log('Evento actualizado emitido desde Editar')
        emit('evento-actualizado')
        cerrarModal()
      } catch (error) {
        console.error('Detalles del error:', error.response?.data)
        errorMsg.value =
          error.response?.data?.detalle ||
          'Ocurrió un error al eliminar el evento. Por favor, inténtelo de nuevo.'
        console.error('Error al eliminar evento:', error)
      }
    }

    const cerrarModal = () => {
      emit('cerrar')
    }

    return {
      evento,
      mensaje, // Asegúrate de retornar mensaje
      errorMsg, // Asegúrate de retornar errorMsg
      EditarEvento,
      cerrarModal,
      actualizarEvento,
      deleteEvent,
    }
  },
}
