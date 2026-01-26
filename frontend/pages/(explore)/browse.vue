<script setup lang="ts">
import { searchTitles } from "~/services";
import type { Title } from "~/types";

const route = useRoute();
const router = useRouter();

const searchQuery = ref((route.query.q as string) || "");

const searchResults = ref<Title[]>([]);
const currentPage = ref(1);
const totalPages = ref(0);

const searchTimeout = ref<NodeJS.Timeout | null>(null);
const isLoading = ref(false);
const isLoadingMore = ref(false);
const loadMoreTrigger = ref<HTMLElement | null>(null);

const resultsWithPoster = computed(() =>
  searchResults.value.filter((item) => item.posterPath),
);

const hasResults = computed(() => searchResults.value.length > 0);
const hasQuery = computed(() => searchQuery.value.trim().length > 0);
const showEmptyState = computed(
  () => hasQuery.value && !hasResults.value && !isLoading.value,
);
const hasMoreTitles = computed(() => currentPage.value < totalPages.value);

const updateUrlParams = () => {
  const query: { q?: string } = {};

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

  try {
    const response = await searchTitles(query, page, false);
    const results = response.results || [];

    if (page === 1) {
      searchResults.value = results;
    } else {
      searchResults.value = [...searchResults.value, ...results];
    }

    totalPages.value = Math.ceil(response.total / response.size);
    currentPage.value = response.page;
  } catch {
    if (page === 1) searchResults.value = [];
  } finally {
    isLoading.value = false;
    isLoadingMore.value = false;
  }
};

watch(searchQuery, (newValue) => {
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }

  updateUrlParams();

  if (!newValue.trim()) {
    searchResults.value = [];
    isLoading.value = false;
    return;
  }

  isLoading.value = true;

  searchTimeout.value = setTimeout(() => {
    performSearch(newValue, 1);
  }, 500);
});

const clearSearch = () => {
  searchQuery.value = "";
};

const loadMoreResults = () => {
  if (isLoadingMore.value || !hasMoreTitles.value || !hasQuery.value) return;

  isLoadingMore.value = true;
  const nextPage = currentPage.value + 1;
  performSearch(searchQuery.value, nextPage);
};

const handleScroll = () => {
  if (!loadMoreTrigger.value || isLoadingMore.value || !hasMoreTitles.value)
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
            placeholder="Search for titles..."
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
            We couldn't find anything matching "{{ searchQuery }}". <br />
            Try different keywords or check for typos.
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
            Search for titles
          </h3>
          <p class="text-neutral-400">Find your favorite shows and movies.</p>
        </div>

        <div v-else-if="hasResults" class="space-y-8">
          <div class="flex flex-wrap justify-center gap-4">
            <TitleThumbnail
              v-for="item in resultsWithPoster"
              :key="item.id"
              :title="item"
            />
          </div>

          <div ref="loadMoreTrigger" class="py-8 text-center">
            <Icon
              v-if="isLoadingMore"
              name="heroicons:arrow-path"
              class="h-6 w-6 text-neutral-400 animate-spin"
            />
            <p v-else-if="hasMoreTitles" class="text-neutral-400 text-sm">
              Scroll for more results
            </p>
            <p v-else class="text-neutral-400 text-sm">End of results</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>
