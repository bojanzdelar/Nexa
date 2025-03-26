export const getTrendingMovies = () => {
  return useAPI("/trending/movie/week");
};

export const getTopRatedMovies = () => {
  return useAPI("/movie/top_rated");
};

export const getActionMovies = () => {
  return useAPI("/discover/movie?with_genres=28");
};

export const getComedyMovies = () => {
  return useAPI("/discover/movie?with_genres=35");
};

export const getHorrorMovies = () => {
  return useAPI("/discover/movie?with_genres=27");
};

export const getRomanceMovies = () => {
  return useAPI("/discover/movie?with_genres=10749");
};

export const getDocumentaryMovies = () => {
  return useAPI("/discover/movie?with_genres=99");
};
