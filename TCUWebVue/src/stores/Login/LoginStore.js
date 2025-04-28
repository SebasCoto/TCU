import { defineStore } from 'pinia'
import LoginService from '@/services/Login/Login.js'
import router from '@/router'
import { nextTick } from 'vue'
export const useLoginStore = defineStore('login', {
  state: () => ({
    userName: null,
    token: null,
    NombreRol: null,
    initialized: false,
  }),

  persist: true,

  actions: {
    async login(usuario) {
      if (!usuario.username || !usuario.Password) {
        throw new Error('Debe completar el usuario y la contraseña.')
      }

      try {
        const response = await LoginService.login(usuario)

        if (!response.Indicador || !response.Datos) {
          throw new Error(response.Mensaje || 'Error en el login.')
        }

        this.userName = response.Datos.NombreUsuario
        this.token = response.Datos.Token || null
        this.NombreRol = response.Datos.NombreRol
        this.initialized = true
        localStorage.setItem('authToken', response.Datos.Token)
        console.log('Token guardado en localStorage:', response.Datos.Token)
        console.log('Usuario guardado en el store:', this.userName)
        console.log('ID de rol guardado en el store:', this.NombreRol)
        router.push('/home')
        return {
          mensaje: response.Mensaje,
          datos: response.Datos,
        }
      } catch (error) {
        console.error('Error durante login:', error)

        if (error?.response?.data?.Mensaje) {
          throw new Error(error.response.data.Mensaje)
        }

        if (error instanceof Error) {
          throw error
        }

        throw new Error('Error en el login.')
      }
    },

    logout() {
      this.userName = null
      this.token = null
      this.NombreRol = null
      this.initialized = true
      localStorage.removeItem('authToken')

      console.log('Usuario y token eliminados del store y localStorage.')
      console.log(this.userName, this.token, this.NombreRol)
      router.replace('/')
    },
  },

  getters: {
    isLoggedIn(state) {
      return !!state.userName && !!state.token && !!state.NombreRol
    },
  },
})
