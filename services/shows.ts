export const getTrendingShows = () => {
  return useAPI("/trending/tv/week");
};

export const getTopRatedShows = () => {
  return useAPI("/tv/top_rated");
};

export const getActionAndAdventureShows = () => {
  return useAPI("/discover/tv?with_genres=10759");
};

export const getComedyShows = () => {
  return useAPI("/discover/tv?with_genres=35");
};

export const getMysteryShows = () => {
  return useAPI("/discover/tv?with_genres=9648");
};

export const getRomanceShows = () => {
  return useAPI("/discover/tv?with_genres=10749");
};

export const getDocumentaryShows = () => {
  return useAPI("/discover/tv?with_genres=99");
};
