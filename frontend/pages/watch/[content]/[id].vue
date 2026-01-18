<script setup lang="ts">
import { getShowDetails, getMovieDetails } from "~/services";
import type { Show, Movie, Season, Episode } from "~/types";

definePageMeta({
  layout: false,
  validate: (route) => {
    return ["tv", "movie"].includes(route.params.content as string);
  },
});

const route = useRoute();
const router = useRouter();

// FIXME: temporary
const videoSource = "/sample-video.mp4";

const titleType = route.params.content as "tv" | "movie";
const titleId = Number(route.params.id);

const titleData = ref<Show | Movie>({} as Show);
const seasonData = ref<Season | null>(null);
const episodeData = ref<Episode | null>(null);
const seasonNumber = ref<number | null>(null);
const episodeNumber = ref<number | null>(null);

const titleRouteName = computed(() => getTitleRouteName(titleData.value));

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
    (ep: Episode) => ep.episodeNumber === nextEpisodeNumber
  );

  if (hasNextEpisodeInSeason)
    return { season: seasonNumber.value, episode: nextEpisodeNumber };

  const nextSeasonNumber = seasonNumber.value + 1;
  const hasNextSeason = (titleData.value as Show).seasons.some(
    (season: Season) => season.seasonNumber === nextSeasonNumber
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

  await fetchSeasonAndEpisode();
};

const fetchSeasonAndEpisode = async () => {
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
      (season: Season) => season.seasonNumber == seasonNumber.value
    );

    if (!season) return;

    const currentDate = new Date();
    season.episodes = season.episodes.filter(
      (episode: Episode) => currentDate >= new Date(episode.airDate)
    );
    seasonData.value = season;
  }

  episodeData.value =
    seasonData.value?.episodes.find(
      (episode: Episode) => episode.episodeNumber == episodeNumber.value
    ) || ({} as Episode);
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

const goToNextEpisode = async () => {
  if (!nextEpisode.value) return;

  const { season: newSeason, episode: newEpisode } = nextEpisode.value;

  seasonNumber.value = newSeason;
  episodeNumber.value = newEpisode;

  await fetchSeasonAndEpisode();

  router.push({
    path: route.path,
    query: { s: newSeason, e: newEpisode },
  });
};

onMounted(() => {
  parseQueryParams();
  fetchData();
});
</script>

<template>
  <PlayerVideo
    :title-type="titleType"
    :title-id="titleId"
    :title-name="titleData.name ? titleData.name : null"
    :episode-name="episodeData ? episodeData.name : null"
    :title-source="videoSource"
    :has-next-episode="nextEpisode != null"
    @view-details="viewDetails"
    @next-episode="goToNextEpisode"
  />
</template>
