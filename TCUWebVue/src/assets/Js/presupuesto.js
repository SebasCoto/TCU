import { ref } from 'vue'
import { registrarPresupuesto } from '@/services/Familias/FamiliasService'

export const montoTotal = ref(0)
export const isLoading = ref(false)
export const errorMessage = ref('')
export const successMessage = ref('')

export const handleRegistrarPresupuesto = async () => {
  isLoading.value = true

  if (montoTotal.value === 0) {
    errorMessage.value = 'El monto total no puede ser 0'
    isLoading.value = false
    return
  }

  try {
    const result = await registrarPresupuesto(montoTotal.value)
    successMessage.value = result.Mensaje
    errorMessage.value = ''
  } catch (error) {
    errorMessage.value = error.response?.data?.Mensaje || 'Error registrando presupuesto'
    successMessage.value = ''
  } finally {
    isLoading.value = false
  }
}
