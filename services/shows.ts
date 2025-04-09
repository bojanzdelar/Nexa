import type { ContentResponse, Show, Credits, Season } from "~/types";

export const getTrendingShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/trending/tv/week");
};

export const getTopRatedShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/tv/top_rated");
};

export const getAiringTodayShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/tv/airing_today");
};

export const getPopularShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/tv/popular");
};

export const getUpcomingShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/tv/on_the_air");
};

export const getActionAndAdventureShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/discover/tv?with_genres=10759");
};

export const getComedyShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/discover/tv?with_genres=35");
};

export const getMysteryShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/discover/tv?with_genres=9648");
};

export const getRomanceShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/discover/tv?with_genres=10749");
};

export const getDocumentaryShows = () => {
  return useApiForSsr<ContentResponse<Show>>("/discover/tv?with_genres=99");
};

export const getShowDetails = (id: number) => {
  return useApiForSsr<Show>(`/tv/${id}`);
};

export const getShowCredits = (id: number) => {
  return useApiForSsr<Credits>(`/tv/${id}/credits`);
};

export const getSimilarShows = (id: number) => {
  return useApiForSsr<ContentResponse<Show>>(`/tv/${id}/similar`);
};

export const getShowSeasonDetails = (showId: number, seasonNumber: number) => {
  return useApiForSsr<Season>(`/tv/${showId}/season/${seasonNumber}`);
};
