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
      <button
        class="flex items-center gap-x-2 rounded px-5 py-1.5 text-sm font-semibold transition hover:opacity-75 md:px-8 md:py-2.5 md:text-xl bg-white text-black"
      >
        <Icon
          name="heroicons:play-solid"
          class="h-4 w-4 text-black md:h-7 md:w-7"
        />
        Play
      </button>

      <NuxtLink
        :to="{
          name: currentContentInfo.routeName,
          params: {
            id: currentContent.id,
          },
        }"
      >
        <button
          class="flex items-center gap-x-2 rounded px-5 py-1.5 text-sm font-semibold transition hover:opacity-75 md:px-8 md:py-2.5 md:text-xl bg-neutral-500/70"
        >
          More Info
          <Icon
            name="heroicons:information-circle"
            class="h-5 w-5 md:h-8 md:w-8"
          />
        </button>
      </NuxtLink>
    </div>
  </div>
</template>
