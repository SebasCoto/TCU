<script setup>
import Sidebar from '@/components/Sidebar.vue'
import NavBar from '@/components/NavBar.vue'
</script>

<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="w-64 bg-gray-900 text-white flex-shrink-0">
      <Sidebar />
    </aside>

    <!-- Main content -->
    <div class="flex-1 flex flex-col">
      <NavBar />

      <main class="p-6 overflow-auto flex-1 bg-gray-100">
        <div class="bg-white rounded-lg shadow-lg p-6 h-auto">
          <router-view />
        </div>
      </main>
    </div>
  </div>
</template>
