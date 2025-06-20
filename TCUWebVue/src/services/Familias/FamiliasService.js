import Api from '../Api'

export function ObtenerFamilias() {
  return Api.get('/Familias/ObtenerFamilias')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se puedo obtener las familias'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function ObtenerFamiliaById(id) {
  return Api.get(`/Familias/ObtenerFamiliaById?id=${id}`)
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se pudo obtener la familia'))
      }
    })
    .catch((error) => {
      console.error('Error fetching user by ID:', error)
      throw error
    })
}

export function ObtenerVulnerabilidades() {
  return Api.get('/Familias/ObtenerVulnerabilidad')
    .then((response) => {
      if (response.status === 200) {
        return response.data.Datos
      } else {
        return Promise.reject(new Error('No se puedo obtener las vulnerabilidades'))
      }
    })
    .catch((error) => {
      console.error('Error fetching events by ID:', error)
      throw error
    })
}

export function registrarFamilia(familia) {
  return Api.post('/Familias/RegistrarFamilia', familia)
    .then((response) => {
      if (response.status === 200) {
        console.log('La familia ha sido ingresada correctamente:', response.data)
        return response.data
      } else {
        console.log('Register Faild:')
        return Promise.reject(new Error('Register failed'))
      }
    })
    .catch((error) => {
      console.error('Error registering:', error)
      throw error
    })
}

export function actualizarFamilia(familia) {
  return Api.put('/Familias/ActualizarFamilia', familia)
    .then((response) => {
      if (response.status === 200) {
        console.log('La familia ha sido ingresada correctamente:', response.data)
        return response.data
      } else {
        console.log('Register Faild:')
        return Promise.reject(new Error('Register failed'))
      }
    })
    .catch((error) => {
      console.error('Error registering:', error)
      throw error
    })
}

export function eliminarFamilia(id) {
  return Api.delete('/Familias/EliminarFamilia', { params: { id } })
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        console.log('delete Faild:')
        return Promise.reject(new Error('delete failed'))
      }
    })
    .catch((error) => {
      console.error('Error registering:', error)
      throw error
    })
}

export function registrarPresupuesto(montoTotal) {
  return Api.post(`/Presupuesto/RegistrarPresupuesto?MontoTotal=${montoTotal}`)
    .then((response) => {
      if (response.status === 200) {
        return response.data
      } else {
        console.log('Error registering:', response.data)
        return Promise.reject(new Error('Error registering'))
      }
    })
    .catch((error) => {
      console.error('Error registering:', error)
      throw error
    })
}
