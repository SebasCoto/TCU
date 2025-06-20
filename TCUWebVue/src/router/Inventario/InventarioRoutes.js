const InventarioRoutes = [
  {
    path: '/obtenerInventario',
    name: 'obtenerInventario',
    component: () => import('@/views/Inventario/ObtenerInventario.vue'),
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: '/agregarProducto',
    name: 'agregarProducto',
    component: () => import('@/views/Inventario/AgregarProducto.vue'),
    meta: {
      requiresAuth: true,
    },
  },
]

export default InventarioRoutes
