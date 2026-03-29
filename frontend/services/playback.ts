import type {
  ContinueWatchingRef,
  ContinueWatchingItem,
  TitleSummary,
  EpisodeProgressPayload,
  MovieProgressPayload,
} from "~/types";

export const getContinueWatching = async () => {
  const items = await useServiceApiForCsr<ContinueWatchingRef[]>(
    `/me/playback/continue-watching`,
  );
  if (!items.length) return [];

  const summaries = await useServiceApiForCsr<TitleSummary[]>(`/titles/batch`, {
    method: "POST",
    body: items.map((i) => ({
      id: i.id,
      type: i.type,
    })),
  });

  const summaryMap = new Map(summaries.map((s) => [`${s.id}-${s.type}`, s]));

  return items
    .map((i) => {
      const summary = summaryMap.get(`${i.id}-${i.type}`);
      if (!summary) return null;

      return {
        ...i,
        name: summary.name,
        posterPath: summary.posterPath,
      };
    })
    .filter((i): i is ContinueWatchingItem => i !== null);
};

export const getEpisodeProgress = (
  tvId: number,
  season: number,
  episode: number,
) => {
  return useServiceApiForCsr<{
    progressSeconds: number;
  }>(`/me/playback/tv/${tvId}/season/${season}/episode/${episode}`);
};

export const getMovieProgress = (movieId: number) => {
  return useServiceApiForCsr<{
    progressSeconds: number;
  }>(`/me/playback/movie/${movieId}`);
};

export const saveEpisodeProgress = (payload: EpisodeProgressPayload) => {
  return useServiceApiForCsr("/me/playback/episode/progress", {
    method: "POST",
    body: payload,
  });
};

export const saveMovieProgress = (payload: MovieProgressPayload) => {
  return useServiceApiForCsr("/me/playback/movie/progress", {
    method: "POST",
    body: payload,
  });
};

export const clearTvProgress = (tvId: number) => {
  return useServiceApiForCsr(`/me/playback/tv/${tvId}`, {
    method: "DELETE",
  });
};

export const clearEpisodeProgress = (
  tvId: number,
  season: number,
  episode: number,
) => {
  return useServiceApiForCsr(
    `/me/playback/tv/${tvId}/season/${season}/episode/${episode}`,
    {
      method: "DELETE",
    },
  );
};

export const clearMovieProgress = (movieId: number) => {
  return useServiceApiForCsr(`/me/playback/movie/${movieId}`, {
    method: "DELETE",
  });
};
