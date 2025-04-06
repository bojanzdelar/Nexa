<script setup lang="ts">
import type { Show, Movie } from "~/types";

const props = defineProps<{
  content: Show[] | Movie[];
}>();

const currentContent = ref<Show | Movie>(props.content[0]);

const currentContentInfo = computed(() => getContentType(currentContent.value));

const changeContent = () => {
  currentContent.value =
    props.content[Math.floor(Math.random() * props.content.length)];
};

useIntervalFn(changeContent, 10000);
</script>

<template>
  <div
    class="flex flex-col space-y-2 py-16 md:space-y-4 h-[60vh] md:h-[75vh] justify-end lg:pb-12"
  >
    <ContentBackdrop :content="currentContent" class="opacity-75" />

    <h1 class="text-2xl text-shadow-md font-bold md:text-4xl lg:text-7xl">
      {{ currentContentInfo.title }}
    </h1>

    <p
      class="max-w-xs text-md text-shadow-md md:max-w-lg md:text-lg lg:max-w-2xl lg:text-2xl hidden sm:block"
    >
      {{
        currentContent.overview.length > 300
          ? currentContent.overview.slice(0, 300) + "..."
          : currentContent.overview
      }}
    </p>

    <div class="flex space-x-3">
      <CommonButton icon="play-solid" text="Play" />

      <NuxtLink
        :to="{
          name: 'content-id',
          params: {
            content: currentContentInfo.routeName,
            id: currentContent.id,
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
