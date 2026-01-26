import type { CategoryResponse, Movie } from "~/types";

export const getTrendingMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/trending");
};

export const getTopRatedMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/top-rated");
};

export const getNowPlayingMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/latest");
};

export const getActionMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/genres/28");
};

export const getComedyMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/genres/35");
};

export const getDramaMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/genres/18");
};

export const getThrillerMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/genres/53");
};

export const getScienceFictionMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/genres/878");
};

export const getAdventureMovies = (ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>("/movies/genres/12");
};

export const getMovieDetails = (id: number, ssr: boolean = true) => {
  return useCatalogApi(ssr)<Movie>(`/movies/${id}`);
};
