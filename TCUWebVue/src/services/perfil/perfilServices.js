import Api from '../Api'

export function obtenerPerfil() {
  return Api.get('/Usuario/ObtenerPerfil')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('Mal no se pudo obtener el perfil'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function obtenerRoles() {
  return Api.get('/Usuario/ObtenerRoles')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('Mal no se pudo obtener los roles'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function actualizarPerfil(data) {
  return Api.put('/Usuario/ActualizarPerfil', data)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('Mal no se pudo actualizar el perfil'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function cambiarContrasena(data) {
  return Api.put('/Usuario/ActualizarContrasenna', data)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo cambiar la contraseña'))
      }
    })
    .catch((error) => {
      const errorMsg =
        error.response?.data?.Mensaje ||
        error.response?.data?.mensaje ||
        error.message ||
        'Error desconocido'
      console.error('Error al cambiar contraseña:', errorMsg)
      throw new Error(errorMsg)
    })
}
