import type { ContentResponse, Movie, Credits } from "~/types";

export const getTrendingMovies = () => {
  return useAPI<ContentResponse<Movie>>("/trending/movie/week");
};

export const getTopRatedMovies = () => {
  return useAPI<ContentResponse<Movie>>("/movie/top_rated");
};

export const getNowPlayingMovies = () => {
  return useAPI<ContentResponse<Movie>>("/movie/now_playing");
};

export const getPopularMovies = () => {
  return useAPI<ContentResponse<Movie>>("/movie/popular");
};

export const getUpcomingMovies = () => {
  return useAPI<ContentResponse<Movie>>("/movie/upcoming");
};

export const getActionMovies = () => {
  return useAPI<ContentResponse<Movie>>("/discover/movie?with_genres=28");
};

export const getComedyMovies = () => {
  return useAPI<ContentResponse<Movie>>("/discover/movie?with_genres=35");
};

export const getHorrorMovies = () => {
  return useAPI<ContentResponse<Movie>>("/discover/movie?with_genres=27");
};

export const getRomanceMovies = () => {
  return useAPI<ContentResponse<Movie>>("/discover/movie?with_genres=10749");
};

export const getDocumentaryMovies = () => {
  return useAPI<ContentResponse<Movie>>("/discover/movie?with_genres=99");
};

export const getMovieDetails = (id: number) => {
  return useAPI<Movie>(`/movie/${id}`);
};

export const getMovieCredits = (id: number) => {
  return useAPI<Credits>(`/movie/${id}/credits`);
};

export const getSimilarMovies = (id: number) => {
  return useAPI<ContentResponse<Movie>>(`/movie/${id}/similar`);
};
