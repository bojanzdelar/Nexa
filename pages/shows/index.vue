<script setup lang="ts">
import {
  getTrendingShows,
  getTopRatedShows,
  getActionAndAdventureShows,
  getComedyShows,
  getMysteryShows,
  getRomanceShows,
  getDocumentaryShows,
} from "~/services";

const [
  trendingNow,
  topRated,
  actionAndAdventureShows,
  comedyShows,
  mysteryShows,
  romanceShows,
  documentaryShows,
] = (
  await Promise.all([
    getTrendingShows(),
    getTopRatedShows(),
    getActionAndAdventureShows(),
    getComedyShows(),
    getMysteryShows(),
    getRomanceShows(),
    getDocumentaryShows(),
  ])
).map((response) => response.data.value?.results || []);
</script>

<template>
  <div>
    <Head>
      <title>TV Shows - Nexa</title>
    </Head>

    <HomeHeader />
    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <HomeTrending :content="trendingNow" />
      <section class="space-y-5 md:space-y-10">
        <ContentGroup title="Trending Now" :content="trendingNow" />
        <ContentGroup title="Top Rated" :content="topRated" />
        <ContentGroup
          title="Action & Adventure"
          :content="actionAndAdventureShows"
        />
        <ContentGroup title="Comedy" :content="comedyShows" />
        <ContentGroup title="Mystery" :content="mysteryShows" />
        <ContentGroup title="Romance" :content="romanceShows" />
        <ContentGroup title="Documentaries" :content="documentaryShows" />
      </section>
    </main>
  </div>
</template>
