<script setup lang="ts">
import type { Show, Movie } from "~/types";

const props = defineProps<{
  titles: Array<Show | Movie>;
}>();

const currentTitle = ref<Show | Movie>(props.titles[0]);

const currentTitleRouteName = computed(() =>
  getTitleRouteName(currentTitle.value)
);

const changeTitle = () =>
  (currentTitle.value = getRandomElement(props.titles)!);

changeTitle();

useIntervalFn(changeTitle, 10000);
</script>

<template>
  <div
    class="flex flex-col space-y-2 py-16 md:space-y-4 h-[60vh] md:h-[75vh] justify-end lg:pb-12"
  >
    <TitleBackdrop :title="currentTitle" class="opacity-75" />

    <h1 class="text-2xl text-shadow-md font-bold md:text-4xl lg:text-7xl">
      {{ currentTitle.name }}
    </h1>

    <div class="line-clamp-6">
      <p
        class="text-md text-shadow-md md:max-w-lg md:text-lg lg:max-w-2xl lg:text-2xl hidden sm:block"
      >
        {{ currentTitle.tagline }}
      </p>
    </div>

    <div class="flex space-x-3">
      <NuxtLink
        :to="{
          name: 'watch-content-id',
          params: {
            content: currentTitle.type,
            id: currentTitle.id,
          },
        }"
      >
        <CommonButton icon="play-solid" text="Play" />
      </NuxtLink>

      <NuxtLink
        :to="{
          name: 'content-id',
          params: {
            content: currentTitleRouteName,
            id: currentTitle.id,
          },
        }"
      >
        <CommonButton
          icon="information-circle"
          text="More Info"
          class="!bg-neutral-500/70 text-white"
        />
      </NuxtLink>
    </div>
  </div>
</template>
