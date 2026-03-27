import type { CategoryResponse, Show } from "~/types";

export const getTrendingShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/trending");
};

export const getTopRatedShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/top-rated");
};

export const getAiringTodayShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/latest");
};

export const getDramaShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/genres/18");
};

export const getSciFiFantasyShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/genres/10765");
};

export const getComedyShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/genres/35");
};

export const getCrimeShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/genres/80");
};

export const getMysteryShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/genres/9648");
};

export const getActionAndAdventureShows = () => {
  return useServiceApi(true)<CategoryResponse<Show>>("/tv/genres/10759");
};

export const getShowDetails = (id: number, ssr: boolean = true) => {
  return useServiceApi(ssr)<Show>(`/tv/${id}`);
};
