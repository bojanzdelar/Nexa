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
  runtime: number;
  vote_average: number;
  adult: boolean;
  genres: Genre[];
}

export interface Movie extends Content {
  title: string;
  release_date: string;
}

export interface Show extends Content {
  name: string;
  first_air_date: string;
  last_air_date: string;
  number_of_seasons: number;
}

export interface Genre {
  id: number;
  name: string;
}
