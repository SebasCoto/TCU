import Api from '../Api'

export function ObtenerVoluntarios() {
  return Api.get('/Usuario/ObtenerUsuarios')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se puedo obtener los usuarios'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function ObtenerUsuarioById(id) {
  return Api.get(`/Usuario/ObtenerUsuarioById?id=${id}`)
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se pudo obtener el usuario'))
      }
    })
    .catch((error) => {
      console.error('Error fetching user by ID:', error)
      throw error
    })
}

export function ActualizarUsuario(data) {
  return Api.put('/Usuario/ActualizarUsuario', data)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('Mal no se pudo actualizar el usuario'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function EliminarUsuario(id) {
  return Api.delete('/Usuario/EliminarUsuario', { params: { id } })
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se pudo eliminar el usuario'))
      }
    })
    .catch((error) => {
      console.error('Error fetching user by ID:', error)
      throw error
    })
}
