const UsuarioRoutes = [
  {
    path: '/obtenerUsuarios',
    name: 'obtenerUsuarios',
    component: () => import('@/views/Usuarios/ObtenerUsuarios.vue'),
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: '/Usuario/:id',
    name: 'EditarUsuario',
    component: () => import('@/views/Usuarios/EditarUsuarios.vue'),
    props: (route) => ({ id: route.params.id, voluntario: route.params.voluntario }),
  },
  {
    path: '/UsuarioEspera',
    name: 'UsuariosEspera',
    component: () => import('@/views/Usuarios/UsuariosEspera.vue'),
    meta: {
      requiresAuth: true,
    },
  },
]

export default UsuarioRoutes
