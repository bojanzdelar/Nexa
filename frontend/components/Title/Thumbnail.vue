<script setup lang="ts">
import { useAuthStore, useMyListStore } from "~/store";
import type { Title } from "~/types";

const props = defineProps<{
  title: Title;
}>();

const authStore = useAuthStore();
const { isAuthenticated } = storeToRefs(authStore);

const { isInMyList, addToMyList, removeFromMyList } = useMyListStore();

const titleRouteName = computed(() => getTitleRouteName(props.title));
</script>

<template>
  <div
    class="group relative w-[160px] md:w-[180px] lg:w-[200px] shrink-0 cursor-pointer transition ease-out md:hover:scale-105"
  >
    <NuxtLink
      :to="{
        name: 'content-id',
        params: {
          content: titleRouteName,
          id: title.id,
        },
      }"
    >
      <NuxtImg
        :src="`https://image.tmdb.org/t/p/w300${title.posterPath}`"
        class="rounded-sm md:rounded opacity-75 hover:opacity-100 transition-opacity"
        :alt="title.name"
        format="webp"
      />
    </NuxtLink>

    <button
      v-if="isAuthenticated"
      class="absolute top-2 right-2 p-1 pl-3 pb-3 lg:opacity-0 lg:group-hover:opacity-100 transition-opacity"
    >
      <span v-if="isInMyList(title)" @click="removeFromMyList(title)">
        <Icon name="heroicons:x-mark-solid" class="h-6 w-6 lg:h-9 lg:w-9" />
      </span>
      <span v-else @click="addToMyList(title)">
        <Icon name="heroicons:plus-solid" class="h-6 w-6 lg:h-9 lg:w-9" />
      </span>
    </button>
  </div>
</template>
