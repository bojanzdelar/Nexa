<script setup lang="ts">
import type { Season } from "~/types";

defineProps<{
  season: Season;
}>();
</script>

<template>
  <div class="space-y-4">
    <div class="flex items-center gap-4">
      <h3 class="text-xl font-bold text-neutral-200">
        {{ season.name }}
      </h3>
      <span class="text-neutral-400">
        {{ season.episodes.length }} episodes
      </span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <ShowEpisode
        v-for="episode in season.episodes"
        :key="episode.id"
        :episode="episode"
      />
    </div>
  </div>
</template>
