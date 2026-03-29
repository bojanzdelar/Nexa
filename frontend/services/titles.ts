import type { SearchResponse, TitleSummary } from "~/types";

export const searchTitles = (
  query: string,
  page: number = 1,
  _: boolean = true,
) => {
  return useServiceApiForCsr<SearchResponse<TitleSummary>>("/search", {
    query: {
      q: query,
      page,
    },
  });
};
