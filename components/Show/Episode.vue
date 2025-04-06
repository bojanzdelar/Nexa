<script setup lang="ts">
import type { Episode } from "~/types";

defineProps<{
  episode: Episode;
}>();
</script>

<template>
  <div
    class="bg-neutral-800/50 rounded-lg p-4 hover:bg-neutral-700/50 transition-colors"
  >
    <div class="flex gap-4">
      <div class="w-1/3">
        <NuxtImg
          v-if="episode.still_path"
          :src="`https://image.tmdb.org/t/p/w300${episode.still_path}`"
          :alt="episode.name"
          class="rounded w-full"
        />
        <div
          v-else
          class="bg-neutral-700 w-full aspect-video rounded flex items-center justify-center"
        >
          <span class="text-neutral-400">No image</span>
        </div>
      </div>
      <div class="w-2/3 space-y-2">
        <h4 class="font-semibold">{{ episode.name }}</h4>
        <div class="flex items-center gap-2 text-sm text-neutral-400">
          <span>Episode {{ episode.episode_number }}</span>
          <span>•</span>
          <span>{{ episode.runtime }} min</span>
          <span>•</span>
          <span>{{ new Date(episode.air_date).getFullYear() }}</span>
        </div>
        <p class="text-sm text-neutral-300 line-clamp-3">
          {{ episode.overview || "No overview available." }}
        </p>
      </div>
    </div>
  </div>
</template>
