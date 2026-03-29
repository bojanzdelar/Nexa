import type { CategoryResponse, Movie } from "~/types";

export const getTrendingMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/trending");
};

export const getTopRatedMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/top-rated");
};

export const getNowPlayingMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/latest");
};

export const getActionMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/genres/28");
};

export const getComedyMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/genres/35");
};

export const getDramaMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/genres/18");
};

export const getThrillerMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/genres/53");
};

export const getScienceFictionMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/genres/878");
};

export const getAdventureMovies = () => {
  return useServiceApiForSsr<CategoryResponse<Movie>>("/movies/genres/12");
};

export const getMovieDetails = (id: number, ssr: boolean = true) => {
  if (ssr) {
    return useServiceApiForSsr<Movie>(`/movies/${id}`);
  }

  return useServiceApiForCsr<Movie>(`/movies/${id}`);
};
