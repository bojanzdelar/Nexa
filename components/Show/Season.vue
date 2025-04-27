<script setup lang="ts">
import type { Show, Season, Episode } from "~/types";

const props = defineProps<{
  show: Show;
  season: Season;
}>();

const releasedEpisodes = computed(() => {
  const currentDate = new Date();
  return props.season.episodes.filter(
    (episode: Episode) => currentDate >= new Date(episode.air_date)
  );
});
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
      <NuxtLink
        v-for="episode in releasedEpisodes"
        :key="episode.id"
        :to="{
          name: 'watch-content-id',
          params: {
            content: 'tv',
            id: show.id,
          },
          query: {
            s: season.season_number,
            e: episode.episode_number,
          },
        }"
      >
        <ShowEpisode :episode="episode" />
      </NuxtLink>
    </div>
  </div>
</template>
