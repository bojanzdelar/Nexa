<script setup lang="ts">
import type { Cast } from "~/types";

const config = useRuntimeConfig();

defineProps<{
  person: Cast;
}>();
</script>

<template>
  <div class="group cursor-pointer w-[140px] md:w-[160px] shrink-0">
    <NuxtImg
      :src="config.public.cdnBaseUrl + person.profilePath"
      class="rounded mb-2 object-cover opacity-75 group-hover:opacity-100 transition-opacity"
    />
    <p class="text-neutral-300 text-sm">{{ person.name }}</p>
  </div>
</template>
