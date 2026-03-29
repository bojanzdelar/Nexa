import type { CategoryResponse, Show } from "~/types";

export const getTrendingShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/trending");
};

export const getTopRatedShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/top-rated");
};

export const getAiringTodayShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/latest");
};

export const getDramaShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/genres/18");
};

export const getSciFiFantasyShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/genres/10765");
};

export const getComedyShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/genres/35");
};

export const getCrimeShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/genres/80");
};

export const getMysteryShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/genres/9648");
};

export const getActionAndAdventureShows = () => {
  return useServiceApiForSsr<CategoryResponse<Show>>("/tv/genres/10759");
};

export const getShowDetails = (id: number, ssr: boolean = true) => {
  if (ssr) {
    return useServiceApiForSsr<Show>(`/tv/${id}`);
  }

  return useServiceApiForCsr<Show>(`/tv/${id}`);
};
