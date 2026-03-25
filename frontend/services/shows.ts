import type { CategoryResponse, Show } from "~/types";

export const getTrendingShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/trending");
};

export const getTopRatedShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/top-rated");
};

export const getAiringTodayShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/latest");
};

export const getDramaShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/genres/18");
};

export const getSciFiFantasyShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/genres/10765");
};

export const getComedyShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/genres/35");
};

export const getCrimeShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/genres/80");
};

export const getMysteryShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/genres/9648");
};

export const getActionAndAdventureShows = () => {
  return useCatalogApi(true)<CategoryResponse<Show>>("/tv/genres/10759");
};

export const getShowDetails = (id: number, ssr: boolean = true) => {
  return useCatalogApi(ssr)<Show>(`/tv/${id}`);
};
