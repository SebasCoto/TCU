import { createRouter, createWebHistory } from 'vue-router'
import homeRoutes from '../router/Home/HomeRoutes'
import authRoutes from '../router/Login/LoginController'
import LayoutRoutes from '../router/Layout/LayoutRoutes'
import layoutRoutes from '../router/Layout/LayoutRoutes'
const routes = [
  {
    path: '/',
    name: 'login',
    component: () => import('@/views/Login/Login.vue'),
  },
  ...authRoutes,
  layoutRoutes,
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

export default router
