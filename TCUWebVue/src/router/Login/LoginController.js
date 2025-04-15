const authRoutes = [
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/Login.vue'), // Asegúrate de que el path sea correcto
  },
]

export default authRoutes
