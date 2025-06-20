import Api from '../Api'

export function agregarProducto(data) {
  return Api.post('/Inventario/RegistrarProducto', data)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo registrar el producto'))
      }
    })
    .catch((error) => {
      console.error('Error agregando los productos:', error)
      throw error
    })
}

export function actualizarProducto(data) {
  return Api.put('/Inventario/ActualizarProducto', data)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo registrar el producto'))
      }
    })
    .catch((error) => {
      let mensaje = 'Error al actualizar el producto'
      if (error.response && error.response.data && error.response.data.Mensaje) {
        mensaje = error.response.data.Mensaje
      } else if (error.message) {
        mensaje = error.message
      }
      console.error(mensaje)
      throw new Error(mensaje)
    })
}

export function obtenerCategorias() {
  return Api.get('/Inventario/ObtenerCategorias')
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo obtener las categorias'))
      }
    })
    .catch((error) => {
      console.error('Error al obtener las categorias:', error)
      throw error
    })
}

export function eliminarProducto(id) {
  return Api.delete('/Inventario/EliminarProducto', { params: { id } })
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo eliminar el producto'))
      }
    })
    .catch((error) => {
      console.error('Error al eliminar el producto:', error)
      throw error
    })
}

export function obtenerProductos() {
  return Api.get('Inventario/ObtenerProductos')
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo obtener los productos'))
      }
    })
    .catch((error) => {
      console.error('Error al obtener las categorias:', error)
      throw error
    })
}

export function obtenerProductosById(id) {
  return Api.get(`Inventario/ObtenerProductoById?id=${id}`)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        return Promise.reject(new Error('No se pudo obtener el producto'))
      }
    })
    .catch((error) => {
      console.error('Error al obtener las categorias:', error)
      throw error
    })
}
