<script setup lang="ts">
import { useMyListStore } from "~/store";
import type { Show, Movie } from "~/types";

const props = defineProps<{
  content: Show | Movie;
}>();

const { isInMyList, addToMyList, removeFromMyList } = useMyListStore();

const contentInfo = computed(() => getContentType(props.content));
</script>

<template>
  <div
    class="group relative w-[160px] md:w-[180px] lg:w-[200px] shrink-0 cursor-pointer transition ease-out md:hover:scale-105"
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

    <button
      class="absolute top-2 right-2 p-1 pl-3 pb-3 lg:opacity-0 lg:group-hover:opacity-100 transition-opacity"
    >
      <span v-if="isInMyList(content)" @click="removeFromMyList(content)">
        <Icon name="heroicons:x-mark-solid" class="h-6 w-6 lg:h-9 lg:w-9" />
      </span>
      <span v-else @click="addToMyList(content)">
        <Icon name="heroicons:plus-solid" class="h-6 w-6 lg:h-9 lg:w-9" />
      </span>
    </button>
  </div>
</template>
