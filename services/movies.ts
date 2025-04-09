import type { ContentResponse, Movie, Credits } from "~/types";

export const getTrendingMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/trending/movie/week");
};

export const getTopRatedMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/movie/top_rated");
};

export const getNowPlayingMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/movie/now_playing");
};

export const getPopularMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/movie/popular");
};

export const getUpcomingMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/movie/upcoming");
};

export const getActionMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/discover/movie?with_genres=28");
};

export const getComedyMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/discover/movie?with_genres=35");
};

export const getHorrorMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/discover/movie?with_genres=27");
};

export const getRomanceMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>(
    "/discover/movie?with_genres=10749"
  );
};

export const getDocumentaryMovies = () => {
  return useApiForSsr<ContentResponse<Movie>>("/discover/movie?with_genres=99");
};

export const getMovieDetails = (id: number) => {
  return useApiForSsr<Movie>(`/movie/${id}`);
};

export const getMovieCredits = (id: number) => {
  return useApiForSsr<Credits>(`/movie/${id}/credits`);
};

export const getSimilarMovies = (id: number) => {
  return useApiForSsr<ContentResponse<Movie>>(`/movie/${id}/similar`);
};
