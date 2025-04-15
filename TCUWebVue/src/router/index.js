import { createRouter, createWebHistory } from 'vue-router'
import loginRoutes from '../router/Login/LoginController'
import homeRoutes from '../router/Home/HomeRoutes'

const routes = [
  {
    path: '/',
    name: 'login',
    component: () => import('@/views/Login.vue'), // Asegúrate de que este archivo exista
  },
  ,
  ...homeRoutes,
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

export default router
