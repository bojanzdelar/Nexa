<script setup lang="ts">
import type { Cast } from "~/types";

defineProps<{
  person: Cast;
}>();
</script>

<template>
  <div class="group cursor-pointer min-w-[140px] md:min-w-[160px]">
    <NuxtImg
      :src="`https://image.tmdb.org/t/p/w300${person.profile_path}`"
      :alt="person.name"
      class="rounded mb-2 object-cover opacity-75 group-hover:opacity-100 transition-opacity"
    />
    <p class="text-neutral-300 text-sm">{{ person.name }}</p>
  </div>
</template>
