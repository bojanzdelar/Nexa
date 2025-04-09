<script setup lang="ts">
import {
  getAiringTodayShows,
  getNowPlayingMovies,
  getPopularShows,
  getPopularMovies,
  getUpcomingShows,
  getUpcomingMovies,
} from "~/services";

const [
  airingTodayShows,
  nowPlayingMovies,
  popularShows,
  popularMovies,
  upcomingShows,
  upcomingMovies,
] = (
  await Promise.all([
    getAiringTodayShows(),
    getNowPlayingMovies(),
    getPopularShows(),
    getPopularMovies(),
    getUpcomingShows(),
    getUpcomingMovies(),
  ])
).map((response) => response.data.value?.results || []);
</script>

<template>
  <div>
    <Head>
      <title>New & Popular - Nexa</title>
    </Head>

    <BrowseHeader />
    <main class="pl-4 lg:pl-16 pt-24 md:pt-32 pb-24">
      <section class="space-y-5 md:space-y-10">
        <ContentGroup title="Airing Today Shows" :content="airingTodayShows" />
        <ContentGroup title="Now Playing Movies" :content="nowPlayingMovies" />
        <ContentGroup title="Popular Shows" :content="popularShows" />
        <ContentGroup title="Popular Movies" :content="popularMovies" />
        <ContentGroup title="Upcoming Shows" :content="upcomingShows" />
        <ContentGroup title="Upcoming Movies" :content="upcomingMovies" />
      </section>
    </main>
  </div>
</template>
