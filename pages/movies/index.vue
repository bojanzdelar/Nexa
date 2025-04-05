<script setup lang="ts">
import {
  getTrendingMovies,
  getTopRatedMovies,
  getActionMovies,
  getComedyMovies,
  getHorrorMovies,
  getRomanceMovies,
  getDocumentaryMovies,
} from "~/services";

const [
  trendingNow,
  topRated,
  actionMovies,
  comedyMovies,
  horrorMovies,
  romanceMovies,
  documentaryMovies,
] = (
  await Promise.all([
    getTrendingMovies(),
    getTopRatedMovies(),
    getActionMovies(),
    getComedyMovies(),
    getHorrorMovies(),
    getRomanceMovies(),
    getDocumentaryMovies(),
  ])
).map((response) => response.data.value?.results || []);
</script>

<template>
  <div>
    <Head>
      <title>Movies - Nexa</title>
    </Head>

    <HomeHeader />
    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <HomeTrending :content="trendingNow" />
      <section class="space-y-5 md:space-y-10">
        <ContentGroup title="Trending Now" :content="trendingNow" />
        <ContentGroup title="Top Rated" :content="topRated" />
        <ContentGroup title="Action" :content="actionMovies" />
        <ContentGroup title="Comedy" :content="comedyMovies" />
        <ContentGroup title="Horror" :content="horrorMovies" />
        <ContentGroup title="Romance" :content="romanceMovies" />
        <ContentGroup title="Documentaries" :content="documentaryMovies" />
      </section>
    </main>
  </div>
</template>
