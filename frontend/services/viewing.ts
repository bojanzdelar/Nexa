import type {
  ContinueWatchingRef,
  ContinueWatchingItem,
  TitleSummary,
  EpisodeProgressPayload,
  MovieProgressPayload,
} from "~/types";

export const getContinueWatching = async () => {
  const items = await useApiForCsr<ContinueWatchingRef[]>(
    `/me/viewing/continue-watching`,
  );
  if (!items.length) return [];

  const summaries = await useApiForCsr<TitleSummary[]>(`/titles/batch`, {
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
  return useApiForCsr<{
    progressSeconds: number;
  }>(`/me/viewing/tv/${tvId}/season/${season}/episode/${episode}`);
};

export const getMovieProgress = (movieId: number) => {
  return useApiForCsr<{
    progressSeconds: number;
  }>(`/me/viewing/movie/${movieId}`);
};

export const saveEpisodeProgress = (payload: EpisodeProgressPayload) => {
  return useApiForCsr("/me/viewing/episode/progress", {
    method: "POST",
    body: payload,
  });
};

export const saveMovieProgress = (payload: MovieProgressPayload) => {
  return useApiForCsr("/me/viewing/movie/progress", {
    method: "POST",
    body: payload,
  });
};

export const clearTvProgress = (tvId: number) => {
  return useApiForCsr(`/me/viewing/tv/${tvId}`, {
    method: "DELETE",
  });
};

export const clearEpisodeProgress = (
  tvId: number,
  season: number,
  episode: number,
) => {
  return useApiForCsr(
    `/me/viewing/tv/${tvId}/season/${season}/episode/${episode}`,
    {
      method: "DELETE",
    },
  );
};

export const clearMovieProgress = (movieId: number) => {
  return useApiForCsr(`/me/viewing/movie/${movieId}`, {
    method: "DELETE",
  });
};
