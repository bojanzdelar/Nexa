<script setup lang="ts">
import type { Show, Movie } from "~/types";

defineProps<{
  content: Show | Movie;
}>();
</script>

<template>
  <div
    class="min-w-[160px] md:min-w-[180px] lg:min-w-[200px] cursor-pointer transition duration-200 ease-out md:hover:scale-105"
  >
    <NuxtImg
      :src="`https://image.tmdb.org/t/p/w300${content.poster_path}`"
      class="rounded-sm md:rounded opacity-75 hover:opacity-100"
      :alt="'name' in content ? content.name : content.title"
      format="webp"
    />
  </div>
</template>
