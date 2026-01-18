<script setup lang="ts">
import { getShowDetails, getMovieDetails } from "~/services";
import { useAuthStore, useMyListStore } from "~/store";
import type { Title, Show, Movie, Cast, Season } from "~/types";

definePageMeta({
  validate: (route) => {
    return ["shows", "movies"].includes(route.params.content as string);
  },
});

const route = useRoute();
const router = useRouter();

const titleType = route.params.content as "shows" | "movies";
const titleId = Number(route.params.id);
const seasonQuery = route.query.s ? Number(route.query.s) : 1;

const authStore = useAuthStore();
const { isAuthenticated } = storeToRefs(authStore);

const myListStore = useMyListStore();
const { listsLoaded } = storeToRefs(myListStore);
const { isInMyList, addToMyList, removeFromMyList } = myListStore;

const title = ref<Show | Movie>({} as Show);
const cast = ref<Cast[]>([]);
const recommendedTitles = ref<Title[]>([]);
const seasons = ref<Season[]>([]);
const currentSeasonIndex = ref(0);

const titleRelease = computed(() => getTitleRelease(title.value));
const currentSeason = computed(() => seasons.value[currentSeasonIndex.value]);

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
  const titleData =
    titleType === "shows"
      ? await getShowDetails(titleId)
      : await getMovieDetails(titleId);

  title.value = titleData || ({} as Show | Movie);
  cast.value = title.value.cast;
  recommendedTitles.value = title.value.recommendations;

  if (titleType === "shows") {
    seasons.value = (title.value as Show).seasons.filter(
      (season: Season) => season.seasonNumber != 0
    );

    if (seasonQuery && seasonQuery <= seasons.value.length) {
      currentSeasonIndex.value = seasonQuery - 1;
    }

    updateSeasonInUrl();
  }
};

await fetchData();
</script>

<template>
  <div>
    <Head>
      <Title>{{ title.name }} - Nexa</Title>
    </Head>

    <main v-if="title" class="px-4 lg:px-16">
      <TitleBackdrop :title="title" class="opacity-75 xl:opacity-50" />

      <div class="relative h-[60vh] md:h-[75vh]">
        <div class="absolute bottom-8 md:bottom-15 lg:bottom-20">
          <h1
            class="text-2xl md:text-4xl lg:text-7xl font-bold mb-4 text-shadow-md"
          >
            {{ title.name }}
          </h1>

          <div
            class="flex flex-wrap items-center gap-4 mb-6 text-md md:text-lg lg:text-xl text-shadow-md"
          >
            <span>{{ new Date(titleRelease).getFullYear() }}</span>
            <span>•</span>
            <div class="flex gap-2">
              <span v-for="genre in title?.genres" :key="genre.id">
                {{ genre.name }}
              </span>
            </div>
            <span v-if="'numberOfSeasons' in title">
              {{ title?.numberOfSeasons }}
              {{ title?.numberOfSeasons > 1 ? "Seasons" : "Season" }}
            </span>
            <span v-else>
              {{ Math.floor(title?.runtime / 60) }}h {{ title?.runtime % 60 }}m
            </span>
            <span v-if="title?.adult" class="border px-2 py-0.5 rounded">
              18+
            </span>
          </div>

          <div class="flex gap-3 mb-8">
            <NuxtLink
              v-if="new Date() >= new Date(titleRelease)"
              :to="{
                name: 'watch-content-id',
                params: {
                  content: title.type,
                  id: title.id,
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
                v-if="!isInMyList(title)"
                icon="plus-solid"
                text="Add to My List"
                class="!bg-neutral-500/70 text-white"
                @click="addToMyList(title)"
              />

              <CommonButton
                v-else
                icon="check-solid"
                text="Remove from My List"
                class="!bg-neutral-500/70 text-white"
                @click="removeFromMyList(title)"
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
              {{ title.overview || "No overview available." }}
            </p>
          </div>

          <div
            v-if="title.type === 'tv' && seasons.length > 0"
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

            <ShowSeason :show="title as Show" :season="currentSeason" />
          </div>

          <CommonGroup type="cast" name="Cast" :content="cast" />
        </div>

        <div class="hidden lg:block xl:w-1/4">
          <div class="sticky top-28">
            <NuxtImg
              :src="`https://image.tmdb.org/t/p/w500${title?.posterPath}`"
              :alt="title.name"
              class="rounded shadow-lg"
            />
          </div>
        </div>
      </div>

      <CommonGroup
        type="titles"
        name="Recommendations"
        :content="recommendedTitles"
        empty="We don't have enough data to provide recommendations based on this title."
        class="my-16"
      />
    </main>
  </div>
</template>
