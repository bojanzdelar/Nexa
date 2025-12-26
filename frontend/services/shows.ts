import type { ContentResponse, Show, Credits, Season } from "~/types";

export const getTrendingShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/trending/tv/week");
};

export const getTopRatedShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/tv/top_rated");
};

export const getAiringTodayShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/tv/airing_today");
};

export const getPopularShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/tv/popular");
};

export const getUpcomingShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/tv/on_the_air");
};

export const getActionAndAdventureShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/discover/tv?with_genres=10759");
};

export const getComedyShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/discover/tv?with_genres=35");
};

export const getMysteryShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/discover/tv?with_genres=9648");
};

export const getRomanceShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/discover/tv?with_genres=10749");
};

export const getDocumentaryShows = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>("/discover/tv?with_genres=99");
};

export const getShowDetails = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<Show>(`/tv/${id}`);
};

export const getShowCredits = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<Credits>(`/tv/${id}/credits`);
};

export const getSimilarShows = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>(`/tv/${id}/similar`);
};

export const getShowSeasonDetails = (
  showId: number,
  seasonNumber: number,
  ssr: boolean = true
) => {
  return useApi(ssr)<Season>(`/tv/${showId}/season/${seasonNumber}`);
};

export const searchShows = (
  query: string,
  page: number = 1,
  ssr: boolean = true
) => {
  return useApi(ssr)<ContentResponse<Show>>("/search/tv", {
    query: {
      query,
      page,
    },
  });
};
