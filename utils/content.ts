import type { Show, Movie } from "~/types";

export const getContentType = (content: Show | Movie) => {
  const isShow = "name" in content;

  return {
    isShow,
    isMovie: !isShow,
    type: isShow ? "show" : "movie",
    routeName: isShow ? "shows-id" : "movies-id",
    title: isShow ? (content as Show).name : (content as Movie).title,
  };
};
