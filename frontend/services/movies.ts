import type { CategoryResponse, Movie } from "~/types";

export const getTrendingMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/trending");
};

export const getTopRatedMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/top-rated");
};

export const getNowPlayingMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/latest");
};

export const getActionMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/genres/28");
};

export const getComedyMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/genres/35");
};

export const getDramaMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/genres/18");
};

export const getThrillerMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/genres/53");
};

export const getScienceFictionMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/genres/878");
};

export const getAdventureMovies = () => {
  return useApiForSsr<CategoryResponse<Movie>>("/movies/genres/12");
};

export const getMovieDetails = (id: number, ssr: boolean = true) => {
  if (ssr) {
    return useApiForSsr<Movie>(`/movies/${id}`);
  }

  return useApiForCsr<Movie>(`/movies/${id}`);
};
