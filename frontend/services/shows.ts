import type { CategoryResponse, Show } from "~/types";

export const getTrendingShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/trending");
};

export const getTopRatedShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/top-rated");
};

export const getAiringTodayShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/latest");
};

export const getDramaShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/genres/18");
};

export const getSciFiFantasyShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/genres/10765");
};

export const getComedyShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/genres/35");
};

export const getCrimeShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/genres/80");
};

export const getMysteryShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/genres/9648");
};

export const getActionAndAdventureShows = () => {
  return useApiForSsr<CategoryResponse<Show>>("/tv/genres/10759");
};

export const getShowDetails = (id: number, ssr: boolean = true) => {
  if (ssr) {
    return useApiForSsr<Show>(`/tv/${id}`);
  }

  return useApiForCsr<Show>(`/tv/${id}`);
};
