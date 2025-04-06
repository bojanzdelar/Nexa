<script setup lang="ts">
import { getTrendingShows, getTrendingMovies } from "~/services";

const [trendingShows, trendingMovies] = (
  await Promise.all([getTrendingShows(), getTrendingMovies()])
).map((response) => response.data.value?.results || []);
</script>

<template>
  <div>
    <Head>
      <title>Home - Nexa</title>
    </Head>

    <BrowseHeader />
    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <BrowseTrending :content="[...trendingShows, ...trendingMovies]" />
      <section class="space-y-5 md:space-y-10">
        <ContentGroup title="Trending Shows" :content="trendingShows" />
        <ContentGroup title="Trending Movies" :content="trendingMovies" />
      </section>
    </main>
  </div>
</template>
