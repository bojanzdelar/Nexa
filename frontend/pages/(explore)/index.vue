<script setup lang="ts">
import { useAuthStore, useMyListStore } from "~/store";
import {
  getContinueWatching,
  getTrendingShows,
  getTrendingMovies,
} from "~/services";
import type { ContinueWatchingItem } from "~/types";

const authStore = useAuthStore();

const myListStore = useMyListStore();
const { myList } = storeToRefs(myListStore);

const continueWatching = ref<ContinueWatchingItem[]>([]);

const [trendingShows, trendingMovies] = (
  await Promise.all([getTrendingShows(), getTrendingMovies()])
).map((response) => response?.results || []);

onMounted(async () => {
  if (!authStore.isAuthenticated) return;

  continueWatching.value = await getContinueWatching();
});
</script>

<template>
  <div>
    <Head>
      <Title>Home - Nexa</Title>
    </Head>

    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <TitleFeatured :titles="[...trendingShows, ...trendingMovies]" />
      <section class="space-y-5 md:space-y-10">
        <ClientOnly>
          <CommonGroup
            v-if="authStore.isAuthenticated && continueWatching?.length"
            type="continue"
            name="Continue Watching"
            :content="continueWatching"
          />
          <CommonGroup
            v-if="authStore.isAuthenticated && myList?.length"
            type="titles"
            name="My List"
            :content="myList"
          />
        </ClientOnly>
        <CommonGroup
          type="titles"
          name="Trending Shows"
          :content="trendingShows"
        />
        <CommonGroup
          type="titles"
          name="Trending Movies"
          :content="trendingMovies"
        />
      </section>
    </main>
  </div>
</template>
