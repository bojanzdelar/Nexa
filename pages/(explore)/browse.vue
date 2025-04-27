<script setup lang="ts">
import type { Show, Movie } from "~/types";
import { searchShows, searchMovies } from "~/services";

const route = useRoute();
const router = useRouter();

const searchQuery = ref((route.query.q as string) || "");
const contentType = ref<"tv" | "movie">(
  (route.query.type as "tv" | "movie") || "tv"
);

const searchResults = ref<(Show | Movie)[]>([]);
const currentPage = ref(1);
const totalPages = ref(0);

const searchTimeout = ref<NodeJS.Timeout | null>(null);
const isLoading = ref(false);
const isLoadingMore = ref(false);
const loadMoreTrigger = ref<HTMLElement | null>(null);

const resultsWithPoster = computed(() =>
  searchResults.value.filter((item) => item.poster_path)
);

const hasResults = computed(() => searchResults.value.length > 0);
const hasQuery = computed(() => searchQuery.value.trim().length > 0);
const showEmptyState = computed(
  () => hasQuery.value && !hasResults.value && !isLoading.value
);
const hasMoreContent = computed(() => currentPage.value < totalPages.value);

const updateUrlParams = () => {
  const query: { type: "tv" | "movie"; q?: string } = {
    type: contentType.value,
  };

  if (searchQuery.value.trim()) {
    query.q = searchQuery.value.trim();
  }

  router.replace({ query });
};

const performSearch = async (query: string, page: number = 1) => {
  if (!query.trim()) {
    searchResults.value = [];
    return;
  }

  const response =
    contentType.value === "tv"
      ? await searchShows(query, page, false)
      : await searchMovies(query, page, false);

  const results = response.results || [];

  if (page === 1) {
    searchResults.value = results;
  } else {
    searchResults.value = [...searchResults.value, ...results];
  }

  totalPages.value = response.total_pages || 0;
  currentPage.value = page;
  isLoading.value = false;
  isLoadingMore.value = false;
};

watch(searchQuery, (newValue) => {
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }

  updateUrlParams();

  if (!newValue.trim()) {
    searchResults.value = [];
    return;
  }

  isLoading.value = true;

  searchTimeout.value = setTimeout(() => {
    performSearch(newValue, 1);
  }, 500);
});

watch(contentType, () => {
  window.scrollTo(0, 0);

  updateUrlParams();

  if (hasQuery.value) {
    performSearch(searchQuery.value, 1);
  }
});

const clearSearch = () => {
  searchQuery.value = "";
};

const loadMoreResults = () => {
  if (isLoadingMore.value || !hasMoreContent.value || !hasQuery.value) return;

  isLoadingMore.value = true;
  const nextPage = currentPage.value + 1;
  performSearch(searchQuery.value, nextPage);
};

const handleScroll = () => {
  if (!loadMoreTrigger.value || isLoadingMore.value || !hasMoreContent.value)
    return;

  const rect = loadMoreTrigger.value.getBoundingClientRect();
  const isVisible = rect.top <= window.innerHeight && rect.bottom >= 0;

  if (isVisible && hasQuery.value && hasResults.value) {
    loadMoreResults();
  }
};

useEventListener("scroll", handleScroll);

onMounted(() => {
  if (hasQuery.value) {
    performSearch(searchQuery.value, 1);
  }
});
</script>

<template>
  <div>
    <Head>
      <Title>Browse - Nexa</Title>
    </Head>

    <main class="px-4 lg:px-16 pt-24 md:pt-32 pb-24">
      <section class="space-y-5 md:space-y-10 mx-auto container">
        <div class="flex justify-between">
          <h2 class="text-2xl font-semibold text-neutral-200 text-shadow-md">
            Browse
          </h2>

          <div class="flex space-x-2">
            <button
              v-for="type in [
                { id: 'tv', label: 'TV Shows' },
                { id: 'movie', label: 'Movies' },
              ]"
              :key="type.id"
              class="px-4 py-2 rounded-md text-sm"
              :class="
                contentType === type.id
                  ? 'bg-neutral-700 text-white'
                  : 'text-neutral-400 hover:text-white'
              "
              @click="contentType = type.id as 'tv' | 'movie'"
            >
              {{ type.label }}
            </button>
          </div>
        </div>

        <div
          class="flex items-center bg-neutral-800/60 rounded-md border border-neutral-700"
        >
          <Icon
            name="heroicons:magnifying-glass"
            class="h-6 w-6 ml-4 text-neutral-400"
          />
          <input
            v-model="searchQuery"
            type="text"
            :placeholder="`Search for ${
              contentType === 'tv' ? 'TV shows' : 'movies'
            }...`"
            class="w-full py-4 px-3 bg-transparent text-white focus:outline-none"
          />
          <button
            v-if="searchQuery"
            class="mr-4 text-neutral-400 hover:text-white"
            @click="clearSearch"
          >
            <Icon name="heroicons:x-mark" class="h-5 w-5" />
          </button>
        </div>

        <div v-if="isLoading && !isLoadingMore" class="py-12 text-center">
          <Icon
            name="heroicons:arrow-path"
            class="h-10 w-10 text-neutral-400 animate-spin"
          />
          <p class="mt-4 text-neutral-400">Searching...</p>
        </div>

        <div v-else-if="showEmptyState" class="py-20 text-center">
          <Icon
            name="heroicons:face-frown"
            class="h-16 w-16 text-neutral-500 mx-auto mb-4"
          />
          <h3
            class="text-xl font-semibold text-neutral-200 mb-2 text-shadow-md"
          >
            No results found
          </h3>
          <p class="text-neutral-400">
            We couldn't find anything matching "{{ searchQuery }}" in
            {{ contentType === "tv" ? "TV shows" : "movies" }}. <br />Try
            different keywords or check for typos.
          </p>
        </div>

        <div v-else-if="!hasQuery" class="py-20 text-center">
          <Icon
            name="heroicons:magnifying-glass"
            class="h-16 w-16 text-neutral-500 mx-auto mb-4"
          />
          <h3
            class="text-xl font-semibold text-neutral-200 mb-2 text-shadow-md"
          >
            Search for {{ contentType === "tv" ? "TV shows" : "movies" }}
          </h3>
          <p class="text-neutral-400">
            Find your favorite
            {{ contentType === "tv" ? "TV shows" : "movies" }}.
          </p>
        </div>

        <div v-else-if="hasResults" class="space-y-8">
          <div class="flex flex-wrap justify-center gap-4">
            <ContentThumbnail
              v-for="item in resultsWithPoster"
              :key="item.id"
              :content="item"
            />
          </div>

          <div ref="loadMoreTrigger" class="py-8 text-center">
            <Icon
              v-if="isLoadingMore"
              name="heroicons:arrow-path"
              class="h-6 w-6 text-neutral-400 animate-spin"
            />
            <p v-else-if="hasMoreContent" class="text-neutral-400 text-sm">
              Scroll for more results
            </p>
            <p v-else class="text-neutral-400 text-sm">End of results</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>
