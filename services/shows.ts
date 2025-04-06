import type { ContentResponse, Show, Credits, Season } from "~/types";

export const getTrendingShows = () => {
  return useAPI<ContentResponse<Show>>("/trending/tv/week");
};

export const getTopRatedShows = () => {
  return useAPI<ContentResponse<Show>>("/tv/top_rated");
};

export const getActionAndAdventureShows = () => {
  return useAPI<ContentResponse<Show>>("/discover/tv?with_genres=10759");
};

export const getComedyShows = () => {
  return useAPI<ContentResponse<Show>>("/discover/tv?with_genres=35");
};

export const getMysteryShows = () => {
  return useAPI<ContentResponse<Show>>("/discover/tv?with_genres=9648");
};

export const getRomanceShows = () => {
  return useAPI<ContentResponse<Show>>("/discover/tv?with_genres=10749");
};

export const getDocumentaryShows = () => {
  return useAPI<ContentResponse<Show>>("/discover/tv?with_genres=99");
};

export const getShowDetails = (id: number) => {
  return useAPI<Show>(`/tv/${id}`);
};

export const getShowCredits = (id: number) => {
  return useAPI<Credits>(`/tv/${id}/credits`);
};

export const getSimilarShows = (id: number) => {
  return useAPI<ContentResponse<Show>>(`/tv/${id}/similar`);
};

export const getShowSeasonDetails = (showId: number, seasonNumber: number) => {
  return useAPI<Season>(`/tv/${showId}/season/${seasonNumber}`);
};
