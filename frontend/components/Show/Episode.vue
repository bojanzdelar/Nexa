<script setup lang="ts">
import type { Episode } from "~/types";

const config = useRuntimeConfig();

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
        <div class="relative">
          <NuxtImg
            v-if="episode.stillPath"
            :src="config.public.cdnBaseUrl + episode.stillPath"
            :alt="episode.name"
            class="rounded w-full"
          />
          <div v-else class="bg-neutral-700 w-full aspect-video rounded"></div>

          <div class="absolute inset-0 flex items-center justify-center">
            <button
              class="bg-black/50 hover:bg-black/70 p-2 rounded-full transition-colors"
            >
              <Icon name="heroicons:play-solid" class="h-6 w-6 lg:h-8 lg:w-8" />
            </button>
          </div>
        </div>
      </div>
      <div class="w-2/3 space-y-2">
        <h4 class="font-semibold">{{ episode.name }}</h4>
        <div class="flex items-center gap-2 text-sm text-neutral-400">
          <span>Episode {{ episode.episodeNumber }}</span>
          <span>•</span>
          <span>{{ episode.runtime }} min</span>
          <span>•</span>
          <span>{{ new Date(episode.airDate).getFullYear() }}</span>
        </div>
        <p class="text-sm text-neutral-300 line-clamp-3">
          {{ episode.overview || "No overview available." }}
        </p>
      </div>
    </div>
  </div>
</template>
