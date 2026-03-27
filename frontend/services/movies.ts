import type { CategoryResponse, Movie } from "~/types";

export const getTrendingMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/trending");
};

export const getTopRatedMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/top-rated");
};

export const getNowPlayingMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/latest");
};

export const getActionMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/genres/28");
};

export const getComedyMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/genres/35");
};

export const getDramaMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/genres/18");
};

export const getThrillerMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/genres/53");
};

export const getScienceFictionMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/genres/878");
};

export const getAdventureMovies = () => {
  return useServiceApi(true)<CategoryResponse<Movie>>("/movies/genres/12");
};

export const getMovieDetails = (id: number, ssr: boolean = true) => {
  return useServiceApi(ssr)<Movie>(`/movies/${id}`);
};
