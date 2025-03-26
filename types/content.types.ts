export interface ApiResponse {
  page: number;
  results: Movie[];
  total_pages: number;
  total_results: number;
}

export interface Content {
  id: number;
  overview: string;
  backdrop_path: string;
  poster_path: string;
}

export interface Movie extends Content {
  title: string;
}

export interface Show extends Content {
  name: string;
}
