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
  adult: boolean;
  genres: Genre[];
}

export interface Genre {
  id: number;
  name: string;
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

export interface Season {
  id: number;
  name: string;
  episodes: Episode[];
}

export interface Episode {
  id: number;
  name: string;
  overview: string;
  episode_number: number;
  still_path: string | null;
  air_date: string;
  runtime: number;
}
