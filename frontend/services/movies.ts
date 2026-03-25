import type { CategoryResponse, Movie } from "~/types";

export const getTrendingMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/trending");
};

export const getTopRatedMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/top-rated");
};

export const getNowPlayingMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/latest");
};

export const getActionMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/genres/28");
};

export const getComedyMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/genres/35");
};

export const getDramaMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/genres/18");
};

export const getThrillerMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/genres/53");
};

export const getScienceFictionMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/genres/878");
};

export const getAdventureMovies = () => {
  return useCatalogApi(true)<CategoryResponse<Movie>>("/movies/genres/12");
};

export const getMovieDetails = (id: number, ssr: boolean = true) => {
  return useCatalogApi(ssr)<Movie>(`/movies/${id}`);
};
