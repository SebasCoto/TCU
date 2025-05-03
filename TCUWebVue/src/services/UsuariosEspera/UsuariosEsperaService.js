import Api from '../Api'

export function ObtenerUsuariosEspera() {
  return Api.get('/UsuariosEspera/ObtenerUsuariosEspera')
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

export function ObtenerEstados() {
  return Api.get('/UsuariosEspera/ObtenerEstados')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se puedo obtener los estados'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function AccesoUsuarios(data) {
  // Eliminar la adición manual del mensaje, ya que el mensaje ya está incluido en `data`
  return Api.put('/UsuariosEspera/AccesoUsuarios', data)
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se pudo cambiar el estado de acceso'))
      }
    })
    .catch((error) => {
      console.error('Error actualizando acceso de usuario:', error)
      throw error
    })
}
