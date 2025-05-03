<script setup>
import { onMounted } from 'vue'
import {
  modalCrearVisible,
  modalEditarVisible,
  modalDetalleVisible,
  eventoSeleccionado,
  calendarOptions,
  refrescarEventos,
} from '@/assets/Js/home'

import CrearEventoModal from '@/components/Calendario/CrearEventoModal.vue'
import EditarEventoModal from '@/components/Calendario/EditarEventoModal.vue'
import DetallesEventoModal from '@/components/Calendario/DetallesEventoModal.vue'
import FullCalendar from '@fullcalendar/vue3'

onMounted(async () => {
  await refrescarEventos()
})
</script>

<template>
  <div class="home-wrapper">
    <FullCalendar style="height: 100%; max-height: 100%" v-bind:options="calendarOptions" />

    <!-- Modal de creación de evento -->
    <CrearEventoModal
      :modalVisible="modalCrearVisible"
      @cerrar="modalCrearVisible = false"
      @evento-actualizado="refrescarEventos"
    />
    <EditarEventoModal
      :modalVisible="modalEditarVisible"
      :eventoSeleccionado="eventoSeleccionado"
      @cerrar="modalEditarVisible = false"
      @evento-actualizado="refrescarEventos"
    />

    <DetallesEventoModal
      :modalVisible="modalDetalleVisible"
      :eventoSeleccionado="eventoSeleccionado"
      @cerrar="modalDetalleVisible = false"
    />
  </div>
</template>
<style scoped>
.home-wrapper {
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}
</style>
