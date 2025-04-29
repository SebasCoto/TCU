import Api from '../Api.js'

export function obtenerCorreos(query) {
  return Api.get('/Calendario/ObtenerCorreosSeleccionados', { params: { q: query } })
    .then((response) => {
      if (response.status === 200) {
        return response.data.results // Regresa los resultados obtenidos
      } else {
        return Promise.reject(new Error('Failed to fetch selected emails'))
      }
    })
    .catch((error) => {
      console.error('Error fetching emails:', error)
      throw error // Propaga el error para manejo en el frontend
    })
}

export function guardarEvento(evento) {
  return Api.post('/Calendario/AgregarEvento', evento)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('Failed to save event'))
      }
    })
    .catch((error) => {
      console.error('Error saving event:', error)
      throw error
    })
}

export function obtenerEventos() {
  return Api.get('/Calendario/MostrarEventos')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos // Regresa los eventos obtenidos
      } else {
        return Promise.reject(new Error('Failed to fetch events'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events:', error)
      throw error
    })
}

export function obtenerEventosPorId(id) {
  return Api.get('/Calendario/GetEventById', { params: { id } })
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('Failed to fetch events by ID'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function EditarEvento(evento) {
  return Api.put('/Calendario/EditarEvento', evento)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('Failed to update event'))
      }
    })
    .catch((error) => {
      console.error('Error updating event:', error)
      throw error
    })
}

export function EliminarEvento(id) {
  return Api.delete('/Calendario/EliminarEvento', { params: { id } })
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('Failed to delete event'))
      }
    })
    .catch((error) => {
      console.error('Error deleting event:', error)
      throw error
    })
}
