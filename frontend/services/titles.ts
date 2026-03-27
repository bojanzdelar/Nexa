import type { SearchResponse, TitleSummary } from "~/types";

export const searchTitles = (
  query: string,
  page: number = 1,
  _: boolean = true,
) => {
  return useServiceApi(false)<SearchResponse<TitleSummary>>("/search", {
    query: {
      q: query,
      page,
    },
  });
};
