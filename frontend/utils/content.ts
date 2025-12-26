import type { Show, Movie } from "~/types";

export const getContentType = (content: Show | Movie) => {
  const isShow = "name" in content;

  return {
    isShow,
    isMovie: !isShow,
    type: isShow ? "tv" : "movie",
    routeName: isShow ? "shows" : "movies",
    title: isShow ? (content as Show).name : (content as Movie).title,
    release: isShow
      ? (content as Show).first_air_date
      : (content as Movie).release_date,
  };
};
