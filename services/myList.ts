import type { ContentResponse, Show, Movie } from "~/types";

export const getMyShows = (accountId: number, ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Show>>(
    `/account/${accountId}/watchlist/tv`
  );
};

export const getMyMovies = (accountId: number, ssr: boolean = true) => {
  return useApi(ssr)<ContentResponse<Movie>>(
    `/account/${accountId}/watchlist/movies`
  );
};

export const createMyListItem = (
  accountId: number,
  content: Show | Movie,
  ssr: boolean = true
) => {
  return useApi(ssr)<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: getContentType(content).type,
      media_id: content.id,
      watchlist: true,
    },
  });
};

export const deleteMyListItem = (
  accountId: number,
  content: Show | Movie,
  ssr: boolean = true
) => {
  return useApi(ssr)<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: getContentType(content).type,
      media_id: content.id,
      watchlist: false,
    },
  });
};
