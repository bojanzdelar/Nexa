import type { Cast } from "~/types";

export interface TitleRef {
  id: number;
  type: "movie" | "tv";
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
  genres: Genre[];
  cast: Cast[];
  recommendations: TitleSummary[];
}

export interface Genre {
  id: number;
  name: string;
}
