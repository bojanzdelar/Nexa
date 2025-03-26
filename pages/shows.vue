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
] = await Promise.all([
  getTrendingShows(),
  getTopRatedShows(),
  getActionAndAdventureShows(),
  getComedyShows(),
  getMysteryShows(),
  getRomanceShows(),
  getDocumentaryShows(),
]).then((responses) => responses.map((resp) => resp.data.value?.results || []));
</script>

<template>
  <div>
    <Head>
      <title>Nexa - Watch TV Shows Online, Watch Movies Online</title>
      <link rel="icon" href="/favicon.ico" />
    </Head>

    <HomeHeader />
    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <HomeTrending :content="trendingNow" />
      <section class="space-y-5 md:space-y-10">
        <HomeCategory title="Trending Now" :content="trendingNow" />
        <HomeCategory title="Top Rated" :content="topRated" />
        <HomeCategory
          title="Action & Adventure"
          :content="actionAndAdventureShows"
        />
        <HomeCategory title="Comedy" :content="comedyShows" />
        <HomeCategory title="Mystery" :content="mysteryShows" />
        <HomeCategory title="Romance" :content="romanceShows" />
        <HomeCategory title="Documentaries" :content="documentaryShows" />
      </section>
    </main>
  </div>
</template>
