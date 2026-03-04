export interface CategoryResponse<T> {
  results: T[];
  nextCursor: string;
}

export interface SearchResponse<T> {
  results: T[];
  page: number;
  size: number;
  total: number;
}
