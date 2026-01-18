import type { Title, Show, Movie } from "~/types";

export const getTitleRouteName = (title: Title) => {
  return title.type === "tv" ? "shows" : "movies";
};

export const getTitleRelease = (title: Show | Movie) => {
  return title.type === "tv"
    ? (title as Show).firstAirDate
    : (title as Movie).releaseDate;
};
