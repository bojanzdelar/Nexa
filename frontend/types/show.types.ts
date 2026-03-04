import type { Title } from "~/types";

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
