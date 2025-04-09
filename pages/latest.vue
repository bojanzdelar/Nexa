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
        <CommonGroup
          type="content"
          title="Airing Today Shows"
          :content="airingTodayShows"
        />
        <CommonGroup
          type="content"
          title="Now Playing Movies"
          :content="nowPlayingMovies"
        />
        <CommonGroup
          type="content"
          title="Popular Shows"
          :content="popularShows"
        />
        <CommonGroup
          type="content"
          title="Popular Movies"
          :content="popularMovies"
        />
        <CommonGroup
          type="content"
          title="Upcoming Shows"
          :content="upcomingShows"
        />
        <CommonGroup
          type="content"
          title="Upcoming Movies"
          :content="upcomingMovies"
        />
      </section>
    </main>
  </div>
</template>
