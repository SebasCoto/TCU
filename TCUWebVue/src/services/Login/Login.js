import Api from '../Api.js' // Asegúrate de que la ruta de Api.js sea correcta

function login(usuario) {
  if (usuario.username === '' || usuario.password === '') {
    return Promise.reject(new Error('Username and password are required'))
  }

  return Api.post('/Login/login', usuario) // Realiza la llamada POST a la API

    .then((response) => {
      if (response.status === 200) {
        return response.data // Devuelve solo los datos que necesitas
      } else {
        return Promise.reject(new Error('Login failed'))
      }
    })
    .catch((error) => {
      console.error('Error logging in:', error)
      throw error
    })
}

export default {
  login,
}
