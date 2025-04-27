<script setup lang="ts">
import {
  getShowDetails,
  getMovieDetails,
  getShowSeasonDetails,
} from "~/services";
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

const contentType = route.params.content as "tv" | "movie";
const contentId = Number(route.params.id);

const contentData = ref<Show | Movie>({} as Show);
const seasonData = ref<Season | null>(null);
const episodeData = ref<Episode | null>(null);
const seasonNumber = ref<number | null>(null);
const episodeNumber = ref<number | null>(null);

const contentInfo = computed(() => getContentType(contentData.value));

const nextEpisode = computed(() => {
  if (
    contentType !== "tv" ||
    !seasonData.value ||
    !seasonNumber.value ||
    !episodeNumber.value
  )
    return null;

  const episodes = seasonData.value.episodes;
  const nextEpisodeNumber = episodeNumber.value + 1;

  const hasNextEpisodeInSeason = episodes.some(
    (ep: Episode) => ep.episode_number === nextEpisodeNumber
  );

  if (hasNextEpisodeInSeason)
    return { season: seasonNumber.value, episode: nextEpisodeNumber };

  const nextSeasonNumber = seasonNumber.value + 1;
  const hasNextSeason = (contentData.value as Show).seasons.some(
    (season: Season) => season.season_number === nextSeasonNumber
  );

  if (hasNextSeason) return { season: nextSeasonNumber, episode: 1 };

  return null;
});

const parseQueryParams = () => {
  if (contentType !== "tv") return;

  const { s: season, e: episode } = route.query;
  const hasValidQuery = season && episode;

  if (!hasValidQuery) {
    router.replace({ query: { s: 1, e: 1 } });
  }

  seasonNumber.value = hasValidQuery ? parseInt(season as string) : 1;
  episodeNumber.value = hasValidQuery ? parseInt(episode as string) : 1;
};

const fetchData = async () => {
  if (!contentType || !contentId) return;

  contentData.value =
    contentType === "tv"
      ? await getShowDetails(contentId, false)
      : await getMovieDetails(contentId, false);

  await fetchSeasonAndEpisode();
};

const fetchSeasonAndEpisode = async () => {
  if (
    contentType !== "tv" ||
    seasonNumber.value === null ||
    episodeNumber.value === null
  ) {
    return;
  }

  if (
    seasonData.value === null ||
    seasonNumber.value !== Number(route.query.s)
  ) {
    const season = await getShowSeasonDetails(
      contentId,
      seasonNumber.value,
      false
    );
    const currentDate = new Date();
    season.episodes = season.episodes.filter(
      (episode: Episode) => currentDate >= new Date(episode.air_date)
    );
    seasonData.value = season;
  }

  episodeData.value =
    seasonData.value?.episodes.find(
      (episode: Episode) => episode.episode_number == episodeNumber.value
    ) || ({} as Episode);
};

const viewDetails = () => {
  router.push({
    name: "content-id",
    params: {
      content: contentInfo.value.routeName,
      id: contentId,
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
    :content-type="contentType"
    :content-id="contentId"
    :content-title="contentInfo.title ? contentInfo.title : null"
    :episode-title="episodeData ? episodeData.name : null"
    :content-source="videoSource"
    :has-next-episode="nextEpisode != null"
    @view-details="viewDetails"
    @next-episode="goToNextEpisode"
  />
</template>
