import type { ContentResponse, Movie, Credits } from "~/types";

export const getTrendingMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/trending/movie/week");
};

export const getTopRatedMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/movie/top_rated");
};

export const getNowPlayingMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/movie/now_playing");
};

export const getPopularMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/movie/popular");
};

export const getUpcomingMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/movie/upcoming");
};

export const getActionMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/discover/movie?with_genres=28");
};

export const getComedyMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/discover/movie?with_genres=35");
};

export const getHorrorMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/discover/movie?with_genres=27");
};

export const getRomanceMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>(
    "/discover/movie?with_genres=10749"
  );
};

export const getDocumentaryMovies = (ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>("/discover/movie?with_genres=99");
};

export const getMovieDetails = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<Movie>(`/movie/${id}`);
};

export const getMovieCredits = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<Credits>(`/movie/${id}/credits`);
};

export const getSimilarMovies = (id: number, ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>(`/movie/${id}/similar`);
};

export const searchMovies = (
  query: string,
  page: number = 1,
  ssr: boolean = true
) => {
  return useApi(ssr)<ContentResponse<Movie>>("/search/movie", {
    query: {
      query,
      page,
    },
  });
};
