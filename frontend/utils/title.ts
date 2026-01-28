import type { TitleRef, Show, Movie } from "~/types";

export const getTitleRouteName = <T extends TitleRef>(title: T) => {
  return title.type === "tv" ? "shows" : "movies";
};

export const getTitleRelease = (title: Show | Movie) => {
  return title.type === "tv"
    ? (title as Show).firstAirDate
    : (title as Movie).releaseDate;
};

export const sortByUpdatedDesc = <T extends TitleRef>(a: T, b: T) =>
  new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime();
