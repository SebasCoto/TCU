<script setup>
import Sidebar from '@/components/Sidebar.vue'
import NavBar from '@/components/NavBar.vue'
import {
  montoTotal,
  isLoading,
  errorMessage,
  successMessage,
  handleRegistrarPresupuesto,
} from '@/assets/Js/presupuesto.js'

import { useRoute } from 'vue-router'
const route = useRoute()
</script>

<template>
  <div class="flex h-screen">
    <aside class="w-64 bg-gray-900 text-white flex-shrink-0">
      <Sidebar />
    </aside>

    <div class="flex-1 flex flex-col">
      <NavBar />

      <main class="p-6 overflow-auto flex-1 bg-white">
        <div class="flex gap-4">
          <div class="flex-1 bg-white rounded-lg shadow-lg p-6 h-auto">
            <router-view />
          </div>

          <div
            v-if="route.path === '/obtenerFamilias'"
            class="w-64 bg-white text-black-500 font-bold p-4 rounded-lg shadow-lg h-auto"
          >
            <h1>Presupuesto</h1>
            <input
              v-model="montoTotal"
              type="number"
              class="p-2 rounded-md border border-gray-300"
              placeholder="Monto Total"
            />
            <button
              @click="handleRegistrarPresupuesto"
              :disabled="isLoading"
              class="mt-4 p-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md"
            >
              Registrar Presupuesto
            </button>

            <div v-if="successMessage" class="mt-4 text-green-500">
              <p>{{ successMessage }}</p>
            </div>
            <div v-if="errorMessage" class="mt-4 text-red-500">
              <p>{{ errorMessage }}</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>
