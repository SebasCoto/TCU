const familiasRoutes = [
  {
    path: '/obtenerFamilias',
    name: 'obtenerFamilias',
    component: () => import('@/views/familias/ObtenerFamilias.vue'),
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: '/agregarFamilia',
    name: 'agregarFamilia',
    component: () => import('@/views/familias/AgregarFamilia.vue'),
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: '/editarFamilia/:id',
    name: 'editarFamilia',
    component: () => import('@/views/familias/EditarFamilia.vue'),
    props: (route) => ({ id: route.params.id, familia: route.params.familia }),
  },
]

export default familiasRoutes
