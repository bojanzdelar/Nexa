import type { SearchResponse } from "~/types";

export const searchTitles = (
  query: string,
  page: number = 1,
  _: boolean = true,
) => {
  return useSearchApi<SearchResponse>("/search", {
    query: {
      q: query,
      page,
    },
  });
};
