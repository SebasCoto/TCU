import axios from 'axios'

const Api = axios.create({
  baseURL: 'https://localhost:7216/api',
  headers: {
    'Content-Type': 'application/json',
  },
})

Api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken')

    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }

    return config
  },
  (error) => {
    return Promise.reject(error)
  },
)

Api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      console.warn('Token inválido o expirado')
      localStorage.removeItem('authToken')
      window.location.href = '/'
    }
    return Promise.reject(error)
  },
)

export default Api
