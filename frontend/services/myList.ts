import type { Title, CategoryResponse, Show, Movie } from "~/types";

export const getMyShows = (accountId: number, ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Show>>(
    `/account/${accountId}/watchlist/tv`,
  );
};

export const getMyMovies = (accountId: number, ssr: boolean = true) => {
  return useCatalogApi(ssr)<CategoryResponse<Movie>>(
    `/account/${accountId}/watchlist/movies`,
  );
};

export const createMyListItem = (
  accountId: number,
  title: Title,
  ssr: boolean = true,
) => {
  return useCatalogApi(ssr)<object>(`/account/${accountId}/watchlist`, {
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
  ssr: boolean = true,
) => {
  return useCatalogApi(ssr)<object>(`/account/${accountId}/watchlist`, {
    method: "POST",
    body: {
      media_type: title.type,
      media_id: title.id,
      watchlist: false,
    },
  });
};
