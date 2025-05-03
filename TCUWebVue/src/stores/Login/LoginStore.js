import { defineStore } from 'pinia'
import LoginService from '@/services/Login/Login.js'
import router from '@/router'
import { nextTick } from 'vue'
export const useLoginStore = defineStore('login', {
  state: () => ({
    nombreUsuario: null,
    token: null,
    NombreRol: null,
    apellidos: null,
    userName: null,
    correo: null,
    passwordExp: null,
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

        this.nombreUsuario = response.Datos.NombreUsuario
        this.token = response.Datos.Token || null
        this.NombreRol = response.Datos.NombreRol
        this.apellidos = response.Datos.Apellidos || null
        this.userName = response.Datos.Username || null
        this.correo = response.Datos.Correo || null
        this.passwordExp = response.Datos.password_temp_status || null

        this.initialized = true
        localStorage.setItem('authToken', response.Datos.Token)
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
      this.nombreUsuario = null
      this.token = null
      this.NombreRol = null
      this.apellidos = null
      this.userName = null
      this.correo = null
      this.passwordExp = null
      this.initialized = true
      localStorage.removeItem('authToken')

      console.log('Usuario y token eliminados del store y localStorage.')
      console.log(this.nombreUsuario, this.token, this.NombreRol)
      router.replace('/login')
    },
  },

  getters: {
    isLoggedIn(state) {
      return !!state.username && !!state.token && !!state.NombreRol
    },
  },
})
