import Api from '../Api.js'
import { useRouter } from 'vue-router'

const router = useRouter()
function login(usuario) {
  if (usuario.Username === '' || usuario.Password === '') {
    return Promise.reject(new Error('Username and password are required'))
  }

  return Api.post('/Login/login', usuario)

    .then((response) => {
      if (response.status === 200) {
        console.log('Login successful:', response.data)

        return response.data
      } else {
        console.log('Login Faild:')
        return Promise.reject(new Error('Login failed'))
      }
    })
    .catch((error) => {
      console.error('Error logging in:', error)
      throw error
    })
}

export function register(usuario) {
  return Api.post('/Login/RegistrarUsuario', usuario)

    .then((response) => {
      if (response.status === 200) {
        console.log('Usted esta ha sido añadido a lista de espera:', response.data)
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

export function recuperarAcceso(usuario) {
  return Api.put('/Login/RecuperarContrasenna', usuario)

    .then((response) => {
      if (response.status === 200) {
        console.log('Recuperar exito:', response.data)
        if (response.data.Indicador === false) {
          throw new Error(response.data.Mensaje)
        }
        router.push('/')
        return response.data
      } else {
        console.log('Recuperar Faild:')
        return Promise.reject(new Error('Recuperar failed'))
      }
    })
    .catch((error) => {
      console.error('Error registering:', error)
      throw error
    })
}

export default {
  login,
}
