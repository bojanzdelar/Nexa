<script setup lang="ts">
import {
  getTrendingShows,
  getTopRatedShows,
  getActionAndAdventureShows,
  getComedyShows,
  getMysteryShows,
  getRomanceShows,
  getDocumentaryShows,
  getTrendingMovies,
  getTopRatedMovies,
  getActionMovies,
  getComedyMovies,
  getHorrorMovies,
  getRomanceMovies,
  getDocumentaryMovies,
} from "~/services";

definePageMeta({
  validate: (route) => {
    return ["shows", "movies"].includes(route.params.content as string);
  },
});

const route = useRoute();
const contentType = route.params.content as "shows" | "movies";

const categoryConfigs = {
  shows: {
    "Trending Now": getTrendingShows,
    "Top Rated": getTopRatedShows,
    "Action & Adventure": getActionAndAdventureShows,
    Comedy: getComedyShows,
    Mystery: getMysteryShows,
    Romance: getRomanceShows,
    Documentary: getDocumentaryShows,
  },
  movies: {
    "Trending Now": getTrendingMovies,
    "Top Rated": getTopRatedMovies,
    Action: getActionMovies,
    Comedy: getComedyMovies,
    Horror: getHorrorMovies,
    Romance: getRomanceMovies,
    Documentary: getDocumentaryMovies,
  },
};

const currentConfig = categoryConfigs[contentType];

const categoryNames = Object.keys(currentConfig);

const categoryData = await Promise.all(
  Object.values(currentConfig).map((fn) => fn())
);

const categoriesContent = categoryData.map(
  (response) => response.data.value?.results || []
);

const categoriesToRender = categoryNames.map((name, index) => ({
  title: name,
  content: categoriesContent[index],
  key: `${contentType}-${name.toLowerCase().replace(/\s+/g, "-")}`,
}));
</script>

<template>
  <div>
    <Head>
      <title>
        {{ contentType === "shows" ? "TV Shows" : "Movies" }} - Nexa
      </title>
    </Head>

    <BrowseHeader />
    <main class="pl-4 pb-24 lg:space-y-24 lg:pl-16">
      <BrowseTrending
        :content="
          categoriesToRender.find(
            (category) => category.title == 'Trending Now'
          )?.content
        "
      />
      <section class="space-y-5 md:space-y-10">
        <ContentGroup
          v-for="category in categoriesToRender"
          :key="category.key"
          :title="category.title"
          :content="category.content"
        />
      </section>
    </main>
  </div>
</template>
