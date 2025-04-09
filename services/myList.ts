import type { ContentResponse, Show, Movie } from "~/types";

export const getMyShows = (accountId: number) => {
  return useApi<ContentResponse<Show>>(`/account/${accountId}/watchlist/tv`);
};

export const getMyMovies = (accountId: number) => {
  return useApi<ContentResponse<Movie>>(
    `/account/${accountId}/watchlist/movies`
  );
};

export const createMyListItem = (accountId: number, content: Show | Movie) => {
  return useApi<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: getContentType(content).type,
      media_id: content.id,
      watchlist: true,
    },
  });
};

export const deleteMyListItem = (accountId: number, content: Show | Movie) => {
  return useApi<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: getContentType(content).type,
      media_id: content.id,
      watchlist: false,
    },
  });
};
