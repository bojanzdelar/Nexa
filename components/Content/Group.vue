<script setup lang="ts">
import type { Show, Movie } from "~/types";

const props = withDefaults(
  defineProps<{
    title: string;
    content: Show[] | Movie[];
    empty?: string;
  }>(),
  { empty: "There are no titles in this category." }
);

const contentWithPoster = computed(() =>
  props.content.filter((c) => c.poster_path)
);

const { row, isMoved, isOverflowed, handleClick } = useHorizontalScroll();
</script>

<template>
  <div class="relative space-y-2">
    <h2
      class="cursor-pointer text-lg font-semibold text-neutral-200 transition duration-200 hover:text-white md:text-2xl text-shadow-md"
    >
      {{ title }}
    </h2>
    <div v-if="content.length" class="md:-ml-2">
      <Icon
        name="heroicons:chevron-left"
        class="absolute top-0 bottom-0 left-2 z-10 m-auto h-9 w-9 cursor-pointer transition hover:scale-125"
        :class="{ hidden: !isMoved }"
        @click="handleClick('left')"
      />

      <div
        ref="row"
        class="flex items-center space-x-2.5 overflow-x-scroll scrollbar-hide md:p-2"
      >
        <ContentThumbnail
          v-for="c in contentWithPoster"
          :key="c.id"
          :content="c"
        />
      </div>

      <Icon
        name="heroicons:chevron-right"
        class="absolute top-0 bottom-0 right-2 z-10 m-auto h-9 w-9 cursor-pointer transition hover:scale-125"
        :class="{ hidden: !isOverflowed }"
        @click="handleClick('right')"
      />
    </div>
    <div v-else class="py-16">
      <p class="text-neutral-500">
        {{ empty }}
      </p>
    </div>
  </div>
</template>
