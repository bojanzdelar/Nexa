<script setup lang="ts">
import { clearTvProgress, clearMovieProgress } from "~/services";
import type { ContinueWatchingItem } from "~/types";

const config = useRuntimeConfig();

const props = defineProps<{
  item: ContinueWatchingItem;
}>();

const emit = defineEmits<{
  (e: "removed", id: number, type: string): void;
}>();

const watchRoute = computed(() => {
  if (props.item.type === "tv") {
    return {
      path: `/watch/tv/${props.item.id}`,
      query: {
        s: props.item.season,
        e: props.item.episode,
      },
    };
  }

  return {
    path: `/watch/movie/${props.item.id}`,
  };
});

const removeFromContinueWatching = async () => {
  if (props.item.type === "tv") {
    await clearTvProgress(props.item.id);
  } else {
    await clearMovieProgress(props.item.id);
  }

  emit("removed", props.item.id, props.item.type);
};
</script>

<template>
  <div
    class="group relative w-[160px] md:w-[180px] lg:w-[200px] shrink-0 cursor-pointer transition ease-out md:hover:scale-105"
  >
    <NuxtLink :to="watchRoute">
      <NuxtImg
        :src="config.public.cdnBaseUrl + item.posterPath"
        class="rounded-sm md:rounded opacity-75 hover:opacity-100 transition-opacity"
        :alt="item.name"
        format="webp"
      />
    </NuxtLink>

    <button
      class="absolute top-2 right-2 p-1 pl-3 pb-3 lg:opacity-0 lg:group-hover:opacity-100 transition-opacity"
      @click="removeFromContinueWatching"
    >
      <Icon name="heroicons:x-mark-solid" class="h-6 w-6 lg:h-9 lg:w-9" />
    </button>
  </div>
</template>
