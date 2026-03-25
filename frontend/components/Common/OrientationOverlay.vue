<script setup lang="ts">
defineProps<{
  message: string;
}>();
</script>

<template>
  <div
    class="fixed inset-0 z-50 bg-black text-white flex items-center justify-center text-center p-6"
  >
    <div>
      <p class="text-lg font-semibold">Rotate your device</p>
      <p class="text-sm opacity-70 mt-2">
        {{ message }}
      </p>
    </div>
  </div>
</template>
