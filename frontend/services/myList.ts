import type { Title, TitlesReponse, Show, Movie } from "~/types";

export const getMyShows = (accountId: number, ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Show>>(`/account/${accountId}/watchlist/tv`);
};

export const getMyMovies = (accountId: number, ssr: boolean = true) => {
  return useApi(ssr)<TitlesReponse<Movie>>(
    `/account/${accountId}/watchlist/movies`
  );
};

export const createMyListItem = (
  accountId: number,
  title: Title,
  ssr: boolean = true
) => {
  return useApi(ssr)<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: title.type,
      media_id: title.id,
      watchlist: true,
    },
  });
};

export const deleteMyListItem = (
  accountId: number,
  title: Title,
  ssr: boolean = true
) => {
  return useApi(ssr)<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: title.type,
      media_id: title.id,
      watchlist: false,
    },
  });
};
