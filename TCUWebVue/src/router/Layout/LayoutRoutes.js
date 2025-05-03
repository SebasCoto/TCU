import DefaultLayout from '@/layouts/DefaultLayout.vue'
import homeRoutes from '../Home/HomeRoutes'
import perfilRoutes from '../perfil/perfilRouter'
import UsuarioRoutes from '../Usuarios/UsuariosRoutes'

const layoutRoutes = {
  path: '/',
  component: DefaultLayout,
  children: [...homeRoutes, ...perfilRoutes, ...UsuarioRoutes],
}

export default layoutRoutes
