<script setup lang="ts">
import {
  getShowDetails,
  getShowCredits,
  getSimilarShows,
  getMovieDetails,
  getMovieCredits,
  getSimilarMovies,
  getShowSeasonDetails,
} from "~/services";
import { useAuthStore, useMyListStore } from "~/store";
import type { Show, Movie, Cast, Season } from "~/types";

definePageMeta({
  validate: (route) => {
    return ["shows", "movies"].includes(route.params.content as string);
  },
});

const route = useRoute();
const router = useRouter();

const contentType = route.params.content as "shows" | "movies";
const contentId = Number(route.params.id);
const seasonQuery = route.query.s ? Number(route.query.s) : 1;

const detailsConfig = {
  shows: {
    details: getShowDetails,
    credits: getShowCredits,
    similar: getSimilarShows,
  },
  movies: {
    details: getMovieDetails,
    credits: getMovieCredits,
    similar: getSimilarMovies,
  },
};

const currentConfig = detailsConfig[contentType];

const authStore = useAuthStore();
const { isAuthenticated } = storeToRefs(authStore);

const myListStore = useMyListStore();
const { listsLoaded } = storeToRefs(myListStore);
const { isInMyList, addToMyList, removeFromMyList } = myListStore;

const content = ref<Show | Movie>({} as Show);
const cast = ref<Cast[]>([]);
const similarContent = ref<Show[] | Movie[]>([]);
const seasons = ref<Season[]>([]);
const currentSeasonIndex = ref(0);

const contentInfo = computed(() => getContentType(content.value));
const currentSeason = computed(() => seasons.value[currentSeasonIndex.value]);

const fetchAllSeasons = async () => {
  const show = content.value as Show;
  if (!show.number_of_seasons) return;

  seasons.value = await Promise.all(
    [...Array(show.number_of_seasons)].map((_, index) =>
      getShowSeasonDetails(contentId, index + 1)
    )
  );

  if (seasonQuery && seasonQuery <= seasons.value.length) {
    currentSeasonIndex.value = seasonQuery - 1;
  }

  updateSeasonInUrl();
};

const changeSeason = (direction: "prev" | "next") => {
  if (direction === "prev" && currentSeasonIndex.value > 0) {
    currentSeasonIndex.value--;
  } else if (
    direction === "next" &&
    currentSeasonIndex.value < seasons.value.length - 1
  ) {
    currentSeasonIndex.value++;
  }

  updateSeasonInUrl();
};

const updateSeasonInUrl = () => {
  router.replace({
    query: {
      ...route.query,
      s: currentSeasonIndex.value + 1,
    },
  });
};

const fetchData = async () => {
  const [contentData, creditsData, similarData] = await Promise.all(
    Object.values(currentConfig).map((fn) => fn(contentId))
  );

  content.value = contentData || ({} as Show | Movie);
  cast.value = creditsData?.cast || [];
  similarContent.value = similarData?.results || [];
};

await fetchData();

if (contentType === "shows") {
  await fetchAllSeasons();
}
</script>

<template>
  <div>
    <Head>
      <Title>{{ contentInfo.title }} - Nexa</Title>
    </Head>

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
            <span>{{ new Date(contentInfo.release).getFullYear() }}</span>
            <span>•</span>
            <div class="flex gap-2">
              <span v-for="genre in content?.genres" :key="genre.id">
                {{ genre.name }}
              </span>
            </div>
            <span v-if="'number_of_seasons' in content">
              {{ content?.number_of_seasons }}
              {{ content?.number_of_seasons > 1 ? "Seasons" : "Season" }}
            </span>
            <span v-else>
              {{ Math.floor(content?.runtime / 60) }}h
              {{ content?.runtime % 60 }}m
            </span>
            <span v-if="content?.adult" class="border px-2 py-0.5 rounded">
              18+
            </span>
          </div>

          <div class="flex gap-3 mb-8">
            <NuxtLink
              v-if="new Date() >= new Date(contentInfo.release)"
              :to="{
                name: 'watch-content-id',
                params: {
                  content: contentInfo.type,
                  id: content.id,
                },
              }"
            >
              <CommonButton icon="play-solid" text="Play" />
            </NuxtLink>

            <CommonButton
              v-else
              icon="x-mark-solid"
              text="Upcoming"
              class="!bg-white/75"
            >
            </CommonButton>

            <ClientOnly v-if="isAuthenticated && listsLoaded">
              <CommonButton
                v-if="!isInMyList(content)"
                icon="plus-solid"
                text="Add to My List"
                class="!bg-neutral-500/70 text-white"
                @click="addToMyList(content)"
              />

              <CommonButton
                v-else
                icon="check-solid"
                text="Remove from My List"
                class="!bg-neutral-500/70 text-white"
                @click="removeFromMyList(content)"
              />
            </ClientOnly>
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

          <div
            v-if="contentInfo.isShow && seasons.length > 0"
            class="relative space-y-8"
          >
            <div class="absolute right-0 flex gap-2">
              <button
                :disabled="currentSeasonIndex === 0"
                class="p-2 rounded-full hover:bg-neutral-700/50 transition-colors disabled:opacity-50"
                @click="changeSeason('prev')"
              >
                <Icon name="heroicons:chevron-left" class="w-5 h-5" />
              </button>
              <button
                :disabled="currentSeasonIndex === seasons.length - 1"
                class="p-2 rounded-full hover:bg-neutral-700/50 transition-colors disabled:opacity-50"
                @click="changeSeason('next')"
              >
                <Icon name="heroicons:chevron-right" class="w-5 h-5" />
              </button>
            </div>

            <ShowSeason :show="content as Show" :season="currentSeason" />
          </div>

          <CommonGroup type="cast" title="Cast" :content="cast" />
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

      <CommonGroup
        type="content"
        title="More Like This"
        :content="similarContent"
        class="my-16"
      />
    </main>
  </div>
</template>
