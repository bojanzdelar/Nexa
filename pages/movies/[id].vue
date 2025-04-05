<script setup lang="ts">
import { getMovieDetails, getMovieCredits, getSimilarMovies } from "~/services";
import type { Show, Movie, Cast } from "~/types";

const route = useRoute();
const contentId = route.params.id;

const content = ref<Show | Movie>({} as Show);
const cast = ref<Cast[]>([]);
const similarContent = ref<Show[] | Movie[]>([]);

const contentInfo = computed(() => getContentType(content.value));

const fetchData = async () => {
  const [contentData, creditsData, similarData] = await Promise.all([
    getMovieDetails(Number(contentId)),
    getMovieCredits(Number(contentId)),
    getSimilarMovies(Number(contentId)),
  ]);

  content.value = contentData.data?.value || ({} as Show);
  cast.value = creditsData.data?.value?.cast || [];
  similarContent.value = similarData.data?.value?.results || [];
};

await fetchData();
</script>

<template>
  <div>
    <Head>
      <title>{{ contentInfo.title }} - Nexa</title>
    </Head>

    <HomeHeader />
    <main v-if="content" class="px-4 lg:px-16">
      <ContentBackdrop :content="content" class="opacity-75 xl:opacity-50" />

      <div class="relative h-[60vh] md:h-[75vh]">
        <div class="absolute bottom-8 md:bottom-15 lg:bottom-20">
          <h1
            class="text-2xl md:text-4xl lg:text-7xl font-bold mb-4 text-shadow-md"
          >
            {{ contentInfo.title }}
          </h1>

          <div
            class="flex flex-wrap items-center gap-4 mb-6 text-md md:text-lg lg:text-xl text-shadow-md"
          >
            <span>{{ new Date(content?.release_date).getFullYear() }}</span>
            <span>∘</span>
            <span v-for="genre in content?.genres" :key="genre.id">
              {{ genre.name }}
            </span>
            <span class="border px-2 py-0.5 rounded">
              {{ Math.floor(content?.runtime / 60) }}h
              {{ content?.runtime % 60 }}m
            </span>
            <span v-if="content?.adult" class="border px-2 py-0.5 rounded">
              18+
            </span>
          </div>

          <div class="flex gap-3 mb-8">
            <button
              class="flex items-center gap-x-2 rounded px-5 py-1.5 text-sm font-semibold transition hover:opacity-75 md:px-8 md:py-2.5 md:text-xl bg-white text-black"
            >
              <Icon
                name="heroicons:play-solid"
                class="h-4 w-4 text-black md:h-7 md:w-7"
              />
              Play
            </button>
            <button
              class="flex items-center gap-x-2 rounded px-5 py-1.5 text-sm font-semibold transition hover:opacity-75 md:px-8 md:py-2.5 md:text-xl bg-neutral-500/70"
            >
              <Icon name="heroicons:plus" class="h-5 w-5 md:h-8 md:w-8" />
              My List
            </button>
          </div>
        </div>
      </div>

      <div class="flex gap-12">
        <div class="w-full xl:w-3/4 space-y-16">
          <div class="space-y-2">
            <h2 class="text-lg md:text-2xl font-bold text-neutral-200">
              About
            </h2>
            <p
              class="text-neutral-300 max-w-3xl leading-relaxed text-lg md:text-xl"
            >
              {{ content.overview || "No overview available." }}
            </p>
          </div>

          <CastGroup :cast="cast" />
        </div>

        <div class="hidden lg:block xl:w-1/4">
          <div class="sticky top-28">
            <NuxtImg
              :src="`https://image.tmdb.org/t/p/w500${content?.poster_path}`"
              :alt="contentInfo.title"
              class="rounded shadow-lg"
            />
          </div>
        </div>
      </div>

      <ContentGroup
        title="More Like This"
        :content="similarContent"
        class="my-16"
      />
    </main>
  </div>
</template>
