/**import { defineStore } from 'pinia'
import LoginService from '@/services/LoginService.js'

export const useLoginStore = defineStore('login', {
  state: () => ({
    userName: null,
    token: null,
    idRol: 0,
  }),

  actions: {
    async login(usuario) {
      try {
        const response = await LoginService.login(usuario)
        this.userName = response.userName
        this.token = response.token
        this.idRol = response.idRol
        localStorage.setItem('authToken', response.token) // Guardar el token en el almacenamiento local
      } catch (error) {
        console.error('Error during login:', error)
        throw error // Propagar el error
      }
    },

    logout() {
      this.userName = null
      this.token = null
      this.idRol = 0
      localStorage.removeItem('authToken') // Limpiar el token de localStorage
    },
  },

  getters: {
    isLoggedIn(state) {
      return state.userName !== null && state.token !== null && state.idRol !== 0
    },
  },
})**/
