export interface ContentResponse<T> {
  page: number;
  results: T[];
  total_pages: number;
  total_results: number;
}

export interface Content {
  id: number;
  overview: string;
  backdrop_path: string;
  poster_path: string;
  release_date: string;
  runtime: number;
  vote_average: number;
  adult: boolean;
  genres: Genre[];
}

export interface Movie extends Content {
  title: string;
}

export interface Show extends Content {
  name: string;
}

export interface Genre {
  id: number;
  name: string;
}
