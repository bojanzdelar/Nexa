export interface CategoryResponse<T> {
  results: T[];
  nextCursor: string;
}

export interface SearchResponse {
  results: TitleSummary[];
  page: number;
  size: number;
  total: number;
}

export interface TitleRef {
  id: number;
  type: string;
  updatedAt: string;
}

export interface TitleSummary extends TitleRef {
  name: string;
  posterPath: string;
}

export interface Title extends TitleSummary {
  tagline: string;
  overview: string;
  backdropPath: string;
  runtime: number;
  adult: boolean;
  genres: Genre[];
  cast: Cast[];
  recommendations: TitleSummary[];
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
