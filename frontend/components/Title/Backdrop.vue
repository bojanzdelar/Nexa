<script setup lang="ts">
import type { Show, Movie } from "~/types";

const config = useRuntimeConfig();

defineProps<{
  title: Show | Movie;
}>();
</script>

<template>
  <div
    class="absolute top-0 left-0 -z-10 h-[40vh] sm:h-[65vh] lg:h-[95vh] w-screen"
  >
    <NuxtImg
      :src="config.public.cdnBaseUrl + title.backdropPath"
      class="w-full h-full object-cover object-center"
      :alt="title.name"
    />

    <div
      class="absolute inset-0 bg-gradient-to-b from-neutral-900/50 via-transparent to-neutral-900/100"
    ></div>
  </div>
</template>
