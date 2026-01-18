import type { TitlesReponse, Show } from "~/types";

export const getTrendingShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/trending");
};

export const getTopRatedShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/top-rated");
};

export const getAiringTodayShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/latest");
};

export const getDramaShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/genres/18");
};

export const getSciFiFantasyShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/genres/10765");
};

export const getComedyShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/genres/35");
};

export const getCrimeShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/genres/80");
};

export const getMysteryShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/genres/9648");
};

export const getActionAndAdventureShows = (ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>("/tv/genres/10759");
};

export const getShowDetails = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<Show>(`/tv/${id}`);
};

// export const searchShows = (
//   query: string,
//   page: number = 1,
//   ssr: boolean = true
// ) => {
//   return useApi(ssr)<TitlesReponse<Show>>("/tv/search", {
//     query: {
//       query,
//       page,
//     },
//   });
// };
