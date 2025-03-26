<script setup lang="ts">
import type { Show, Movie } from "~/types";

const config = useRuntimeConfig();

const props = defineProps<{
  content: Show[] | Movie[];
}>();

const trendingContent = ref<Show | Movie>(props.content[0]);

const changeTrendingContent = () => {
  trendingContent.value =
    props.content[Math.floor(Math.random() * props.content.length)];
};

useIntervalFn(changeTrendingContent, 10000);
</script>

<template>
  <div
    class="flex flex-col space-y-2 py-16 md:space-y-4 h-[60vh] md:h-[75vh] justify-end lg:pb-12"
  >
    <div
      class="absolute top-0 left-0 -z-10 h-[40vh] sm:h-[65vh] lg:h-[95vh] w-screen"
    >
      <NuxtImg
        :src="`${config.public.tmdbImageBaseUrl}/${trendingContent.backdrop_path}`"
        class="w-full h-full object-cover opacity-50"
        :alt="
          'name' in trendingContent
            ? trendingContent.name
            : trendingContent.title
        "
      />

      <div
        class="absolute inset-0 bg-gradient-to-b from-neutral-900/50 via-transparent to-neutral-900/100"
      ></div>
    </div>

    <h1 class="text-2xl text-shadow-md font-bold md:text-4xl lg:text-7xl">
      {{
        "name" in trendingContent ? trendingContent.name : trendingContent.title
      }}
    </h1>

    <p
      class="max-w-xs text-md text-shadow-md md:max-w-lg md:text-lg lg:max-w-2xl lg:text-2xl hidden sm:block"
    >
      {{ trendingContent.overview }}
    </p>

    <div class="flex space-x-3">
      <button
        class="flex items-center gap-x-2 rounded px-5 py-1.5 text-sm font-semibold transition hover:opacity-75 md:px-8 md:py-2.5 md:text-xl bg-white text-black"
      >
        <Icon
          name="heroicons:play-solid"
          class="h-4 w-4 text-black md:h-7 md:w-7"
        />
        Play
      </button>

      <button
        class="flex items-center gap-x-2 rounded px-5 py-1.5 text-sm font-semibold transition hover:opacity-75 md:px-8 md:py-2.5 md:text-xl bg-neutral-500/70"
      >
        More Info
        <Icon
          name="heroicons:information-circle"
          class="h-5 w-5 md:h-8 md:w-8"
        />
      </button>
    </div>
  </div>
</template>
