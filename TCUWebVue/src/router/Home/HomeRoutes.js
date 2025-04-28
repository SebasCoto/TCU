const homeRoutes = [
  {
    path: '/home',
    name: 'home',
    component: () => import('@/views/Home.vue'),
    meta: {
      requiresAuth: true,
    },
  },
]

export default homeRoutes
