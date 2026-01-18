<script setup lang="ts">
import { getAiringTodayShows, getNowPlayingMovies } from "~/services";

const [airingTodayShows, nowPlayingMovies] = (
  await Promise.all([getAiringTodayShows(), getNowPlayingMovies()])
).map((response) => response?.results || []);
</script>

<template>
  <div>
    <Head>
      <Title>Latest - Nexa</Title>
    </Head>

    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <TitleFeatured :titles="[...airingTodayShows, ...nowPlayingMovies]" />
      <section class="space-y-5 md:space-y-10">
        <CommonGroup
          type="titles"
          name="Airing Today Shows"
          :content="airingTodayShows"
        />
        <CommonGroup
          type="titles"
          name="Now Playing Movies"
          :content="nowPlayingMovies"
        />
      </section>
    </main>
  </div>
</template>
