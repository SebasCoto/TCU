const authRoutes = [
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/Login/Register.vue'),
  },
  {
    path: '/recuperarAcceso',
    name: 'recuperarAcceso',
    component: () => import('@/views/Login/RecuperarAcceso.vue'),
  },
]

export default authRoutes
