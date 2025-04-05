<script setup lang="ts">
import type { Cast } from "~/types";

const props = defineProps<{
  cast: Cast[];
}>();

const castWithProfile = computed(() =>
  props.cast.filter((c) => c.profile_path)
);

const { row, isMoved, handleClick } = useHorizontalScroll();
</script>

<template>
  <div class="relative space-y-2">
    <h2
      class="text-lg font-semibold text-neutral-200 md:text-2xl text-shadow-md"
    >
      Cast
    </h2>
    <div class="md:-ml-2">
      <Icon
        name="heroicons:chevron-left"
        class="absolute top-0 bottom-0 left-2 z-10 m-auto h-9 w-9 cursor-pointer transition hover:scale-125"
        :class="{ hidden: !isMoved }"
        @click="handleClick('left')"
      />

      <div
        ref="row"
        class="flex items-start space-x-2.5 overflow-x-scroll scrollbar-hide md:p-2"
      >
        <CastThumbnail
          v-for="person in castWithProfile"
          :key="person.id"
          :person="person"
        />
      </div>

      <Icon
        name="heroicons:chevron-right"
        class="absolute top-0 bottom-0 right-2 z-10 m-auto h-9 w-9 cursor-pointer transition hover:scale-125"
        @click="handleClick('right')"
      />
    </div>
  </div>
</template>
