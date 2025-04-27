<script setup lang="ts">
import { getTrendingShows, getTrendingMovies } from "~/services";

const [trendingShows, trendingMovies] = (
  await Promise.all([getTrendingShows(), getTrendingMovies()])
).map((response) => response?.results || []);
</script>

<template>
  <div>
    <Head>
      <Title>Home - Nexa</Title>
    </Head>

    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <ContentTrending :content="[...trendingShows, ...trendingMovies]" />
      <section class="space-y-5 md:space-y-10">
        <CommonGroup
          type="content"
          title="Trending Shows"
          :content="trendingShows"
        />
        <CommonGroup
          type="content"
          title="Trending Movies"
          :content="trendingMovies"
        />
      </section>
    </main>
  </div>
</template>
