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
