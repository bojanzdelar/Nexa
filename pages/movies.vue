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
] = await Promise.all([
  getTrendingMovies(),
  getTopRatedMovies(),
  getActionMovies(),
  getComedyMovies(),
  getHorrorMovies(),
  getRomanceMovies(),
  getDocumentaryMovies(),
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
        <HomeCategory title="Action" :content="actionMovies" />
        <HomeCategory title="Comedy" :content="comedyMovies" />
        <HomeCategory title="Horror" :content="horrorMovies" />
        <HomeCategory title="Romance" :content="romanceMovies" />
        <HomeCategory title="Documentaries" :content="documentaryMovies" />
      </section>
    </main>
  </div>
</template>
