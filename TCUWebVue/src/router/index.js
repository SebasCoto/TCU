import { createRouter, createWebHistory } from 'vue-router'
import authRoutes from '../router/Login/LoginController'
import layoutRoutes from '../router/Layout/LayoutRoutes'
import { useLoginStore } from '@/stores/Login/LoginStore'

const routes = [
  {
    path: '/login',
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

router.beforeEach((to, from, next) => {
  const loginStore = useLoginStore()

  if (loginStore.passwordExp === true && to.path !== '/cambiarContrasena') {
    return next('/cambiarContrasena')
  }

  next()
})

export default router
