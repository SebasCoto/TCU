const perfilRoutes = [
  {
    path: '/perfil',
    name: 'perfil',
    component: () => import('@/views/perfil/perfilLog.vue'),
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: '/cambiarContrasena',
    name: 'cambiarContrasena',
    component: () => import('@/views/perfil/actualizarContrasena.vue'),
    meta: {
      requiresAuth: true,
    },
  },
]

export default perfilRoutes
