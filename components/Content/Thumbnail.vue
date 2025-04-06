<script setup lang="ts">
import type { Show, Movie } from "~/types";

const props = defineProps<{
  content: Show | Movie;
}>();

const contentInfo = computed(() => getContentType(props.content));
</script>

<template>
  <div
    class="min-w-[160px] md:min-w-[180px] lg:min-w-[200px] cursor-pointer transition duration-200 ease-out md:hover:scale-105"
  >
    <NuxtLink
      :to="{
        name: 'content-id',
        params: {
          content: contentInfo.routeName,
          id: content.id,
        },
      }"
    >
      <NuxtImg
        :src="`https://image.tmdb.org/t/p/w300${content.poster_path}`"
        class="rounded-sm md:rounded opacity-75 hover:opacity-100 transition-opacity"
        :alt="contentInfo.title"
        format="webp"
      />
    </NuxtLink>
  </div>
</template>
