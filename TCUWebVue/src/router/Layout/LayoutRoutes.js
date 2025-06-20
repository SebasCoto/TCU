import DefaultLayout from '@/layouts/DefaultLayout.vue'
import homeRoutes from '../Home/HomeRoutes'
import perfilRoutes from '../perfil/perfilRouter'
import UsuarioRoutes from '../Usuarios/UsuariosRoutes'
import familiasRoutes from '../Familias/familiasRoutes'
import InventarioRoutes from '../Inventario/InventarioRoutes'

const layoutRoutes = {
  path: '/',
  component: DefaultLayout,
  children: [
    ...homeRoutes,
    ...perfilRoutes,
    ...UsuarioRoutes,
    ...familiasRoutes,
    ...InventarioRoutes,
  ],
}

export default layoutRoutes
