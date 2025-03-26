<script setup lang="ts">
import type { Show, Movie } from "~/types";

defineProps<{
  title: string;
  content: Show[] | Movie[];
}>();

const row = useTemplateRef("row");
const isMoved = ref(false);

const handleClick = (direction: string) => {
  if (!row.value) return;

  isMoved.value = true;

  const { scrollLeft, clientWidth } = row.value;

  const scrollTo =
    direction === "left" ? scrollLeft - clientWidth : scrollLeft + clientWidth;

  row.value.scrollTo({ left: scrollTo, behavior: "smooth" });
};
</script>

<template>
  <div class="relative space-y-2">
    <h2
      class="cursor-pointer text-lg font-semibold text-neutral-200 transition duration-200 hover:text-white md:text-2xl text-shadow-md"
    >
      {{ title }}
    </h2>
    <div class="group md:-ml-2">
      <Icon
        name="heroicons:chevron-left"
        class="absolute top-0 bottom-0 left-2 z-10 m-auto h-9 w-9 cursor-pointer opacity-0 transition hover:scale-125 group-hover:opacity-100"
        :class="{ hidden: !isMoved }"
        @click="handleClick('left')"
      />

      <div
        ref="row"
        class="flex items-center space-x-2.5 overflow-x-scroll scrollbar-hide md:p-2"
      >
        <HomeThumbnail
          v-for="movie in content"
          :key="movie.id"
          :content="movie"
        />
      </div>

      <Icon
        name="heroicons:chevron-right"
        class="absolute top-0 bottom-0 right-2 z-10 m-auto h-9 w-9 cursor-pointer opacity-100 transition hover:scale-125 group-hover:opacity-100"
        @click="handleClick('right')"
      />
    </div>
  </div>
</template>
