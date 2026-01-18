<script setup lang="ts">
import {
  getTrendingShows,
  getTopRatedShows,
  getDramaShows,
  getSciFiFantasyShows,
  getComedyShows,
  getCrimeShows,
  getMysteryShows,
  getActionAndAdventureShows,
  getTrendingMovies,
  getTopRatedMovies,
  getActionMovies,
  getComedyMovies,
  getDramaMovies,
  getThrillerMovies,
  getScienceFictionMovies,
  getAdventureMovies,
} from "~/services";

definePageMeta({
  validate: (route) => {
    return ["shows", "movies"].includes(route.params.content as string);
  },
});

const route = useRoute();
const titleType = route.params.content as "shows" | "movies";

const categoryConfigs = {
  shows: {
    "Trending Now": getTrendingShows,
    "Top Rated": getTopRatedShows,
    Drama: getDramaShows,
    "Sci-Fi & Fantasy": getSciFiFantasyShows,
    Comedy: getComedyShows,
    Crime: getCrimeShows,
    Mystery: getMysteryShows,
    "Action & Adventure": getActionAndAdventureShows,
  },
  movies: {
    "Trending Now": getTrendingMovies,
    "Top Rated": getTopRatedMovies,
    Action: getActionMovies,
    Comedy: getComedyMovies,
    Drama: getDramaMovies,
    Thriller: getThrillerMovies,
    "Science Fiction": getScienceFictionMovies,
    Adventure: getAdventureMovies,
  },
};

const currentConfig = categoryConfigs[titleType];

const categoryNames = Object.keys(currentConfig);

const categoryData = await Promise.all(
  Object.values(currentConfig).map((fn) => fn())
);

const categoryTitles = categoryData.map((response) => response?.results || []);

const categoriesToRender = categoryNames.map((name, index) => ({
  name,
  titles: categoryTitles[index],
  key: `${titleType}-${name.toLowerCase().replace(/\s+/g, "-")}`,
}));
</script>

<template>
  <div>
    <Head>
      <Title>
        {{ titleType === "shows" ? "TV Shows" : "Movies" }} - Nexa
      </Title>
    </Head>

    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <TitleFeatured
        :titles="
          categoriesToRender.find((category) => category.name == 'Trending Now')
            ?.titles
        "
      />
      <section class="space-y-5 md:space-y-10">
        <CommonGroup
          v-for="category in categoriesToRender"
          :key="category.key"
          type="titles"
          :name="category.name"
          :content="category.titles"
        />
      </section>
    </main>
  </div>
</template>
