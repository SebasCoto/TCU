import DefaultLayout from '@/layouts/DefaultLayout.vue'
import homeRoutes from '../Home/HomeRoutes'

const layoutRoutes = {
  path: '/',
  component: DefaultLayout,
  children: [...homeRoutes],
}

export default layoutRoutes
