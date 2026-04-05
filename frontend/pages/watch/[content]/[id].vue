<script setup lang="ts">
import { getShowDetails, getMovieDetails } from "~/services";
import type { Show, Movie, Season, Episode } from "~/types";

definePageMeta({
  layout: false,
  validate: (route) => {
    return ["tv", "movie"].includes(route.params.content as string);
  },
});

const config = useRuntimeConfig();

const route = useRoute();
const router = useRouter();

const { isMobilePortrait } = useMobileOrientation();

const videoSource = computed(() => {
  if (titleType === "movie") {
    return `${config.public.playback.baseUrl}/playlist/movies/${titleId}`;
  }

  if (seasonNumber.value == null || episodeNumber.value == null) {
    return null;
  }

  return `${config.public.playback.baseUrl}/playlist/shows/${titleId}/s${pad2(seasonNumber.value)}/e${pad2(episodeNumber.value)}`;
});

const titleType = route.params.content as "tv" | "movie";
const titleId = Number(route.params.id);

const titleData = ref<Show | Movie>({} as Show);
const seasonData = ref<Season | null>(null);
const episodeData = ref<Episode | null>(null);
const seasonNumber = ref<number | null>(null);
const episodeNumber = ref<number | null>(null);

const titleRouteName = computed(() => getTitleRouteName(titleData.value));
const pageTitle = computed(() => titleData.value.name);

usePageTitle(pageTitle);

const nextEpisode = computed(() => {
  if (
    titleType !== "tv" ||
    !seasonData.value ||
    !seasonNumber.value ||
    !episodeNumber.value
  )
    return null;

  const episodes = seasonData.value.episodes;
  const nextEpisodeNumber = episodeNumber.value + 1;

  const hasNextEpisodeInSeason = episodes.some(
    (ep: Episode) => ep.episodeNumber === nextEpisodeNumber,
  );

  if (hasNextEpisodeInSeason)
    return { season: seasonNumber.value, episode: nextEpisodeNumber };

  const nextSeasonNumber = seasonNumber.value + 1;
  const hasNextSeason = (titleData.value as Show).seasons.some(
    (season: Season) => season.seasonNumber === nextSeasonNumber,
  );

  if (hasNextSeason) return { season: nextSeasonNumber, episode: 1 };

  return null;
});

const parseQueryParams = () => {
  if (titleType !== "tv") return;

  const { s: season, e: episode } = route.query;
  const hasValidQuery = season && episode;

  if (!hasValidQuery) {
    router.replace({ query: { s: 1, e: 1 } });
  }

  seasonNumber.value = hasValidQuery ? parseInt(season as string) : 1;
  episodeNumber.value = hasValidQuery ? parseInt(episode as string) : 1;
};

const fetchData = async () => {
  if (!titleType || !titleId) return;

  titleData.value =
    titleType === "tv"
      ? await getShowDetails(titleId, false)
      : await getMovieDetails(titleId, false);

  fetchSeasonAndEpisode();
};

const fetchSeasonAndEpisode = () => {
  if (
    titleType !== "tv" ||
    seasonNumber.value === null ||
    episodeNumber.value === null
  ) {
    return;
  }

  if (
    seasonData.value === null ||
    seasonNumber.value !== Number(route.query.s)
  ) {
    const season = (titleData.value as Show).seasons.find(
      (season: Season) => season.seasonNumber == seasonNumber.value,
    );

    if (!season) return;

    const currentDate = new Date();
    season.episodes = season.episodes.filter(
      (episode: Episode) => currentDate >= new Date(episode.airDate),
    );
    seasonData.value = season;
  }

  episodeData.value =
    seasonData.value?.episodes.find(
      (episode: Episode) => episode.episodeNumber == episodeNumber.value,
    ) || ({} as Episode);
};

const formatEpisodeName = (
  seasonNumber: number | null,
  episodeNumber: number | null,
  title: string,
): string | null => {
  if (seasonNumber == null || episodeNumber == null) return null;
  return `S${pad2(seasonNumber)}E${pad2(episodeNumber)} - ${title}`;
};

const viewDetails = () => {
  router.push({
    name: "content-id",
    params: {
      content: titleRouteName.value,
      id: titleId,
    },
    ...(seasonNumber.value !== null && {
      query: {
        s: seasonNumber.value,
      },
    }),
  });
};

const goToNextEpisode = () => {
  if (!nextEpisode.value) return;

  const { season: newSeason, episode: newEpisode } = nextEpisode.value;

  seasonNumber.value = newSeason;
  episodeNumber.value = newEpisode;

  fetchSeasonAndEpisode();

  router.push({
    path: route.path,
    query: { s: newSeason, e: newEpisode },
  });
};

onMounted(async () => {
  try {
    parseQueryParams();
    await fetchData();
  } catch (e) {
    handleFatalError(e);
  }
});
</script>

<template>
  <CommonOrientationOverlay
    v-if="isMobilePortrait"
    message="Switch to landscape to watch"
  />

  <PlayerVideo
    v-else-if="videoSource"
    :key="`${titleType}-${titleId}-${seasonNumber}-${episodeNumber}`"
    :title="titleData"
    :episode-name="
      episodeData
        ? formatEpisodeName(seasonNumber, episodeNumber, episodeData.name)
        : null
    "
    :season="seasonNumber"
    :episode="episodeNumber"
    :title-source="videoSource"
    :has-next-episode="nextEpisode != null"
    @view-details="viewDetails"
    @next-episode="goToNextEpisode"
  />
</template>
