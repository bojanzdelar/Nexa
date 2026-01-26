export interface CategoryResponse<T> {
  results: T[];
  nextCursor: string;
}

export interface SearchResponse {
  results: Title[];
  page: number;
  size: number;
  total: number;
}

export interface Title {
  id: number;
  type: string;
  name: string;
  tagline: string;
  overview: string;
  backdropPath: string;
  posterPath: string;
  runtime: number;
  adult: boolean;
  genres: Genre[];
  cast: Cast[];
  recommendations: Title[];
}

export interface Genre {
  id: number;
  name: string;
}

export interface Movie extends Title {
  releaseDate: string;
}

export interface Show extends Title {
  firstAirDate: string;
  lastAirDate: string;
  numberOfSeasons: number;
  seasons: Season[];
}

export interface Season {
  seasonNumber: number;
  episodes: Episode[];
}

export interface Episode {
  episodeNumber: number;
  name: string;
  overview: string;
  stillPath: string | null;
  airDate: string;
  runtime: number;
}

export interface Subtitle {
  code: string;
  name: string;
}

export interface SubtitleCue {
  start: number;
  end: number;
  text: string;
}

export interface Person {
  id: number;
  name: string;
  profilePath: string;
}

export interface Cast extends Person {
  character: string;
}

export interface Crew extends Person {
  job: string;
}
