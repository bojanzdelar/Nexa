<script setup lang="ts">
defineProps<{
  icon: string;
  text: string;
}>();
</script>

<template>
  <button
    class="flex items-center gap-x-2 rounded px-5 py-1.5 md:px-8 md:py-2.5 text-sm md:text-xl font-semibold bg-white text-black hover:opacity-75"
  >
    <Icon :name="`heroicons:${icon}`" class="h-4 w-4 md:h-7 md:w-7" />
    {{ text }}
  </button>
</template>
