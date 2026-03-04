export interface ContinueWatchingRef {
  id: number;
  type: string;
  season: number | null;
  episode: number | null;
  updatedAt: string;
}

export interface ContinueWatchingItem extends ContinueWatchingRef {
  name: string;
  posterPath: string;
}

export interface EpisodeProgressPayload {
  tvId: number;
  season: number;
  episode: number;
  progressSeconds: number;
  durationSeconds: number;
}

export interface MovieProgressPayload {
  movieId: number;
  progressSeconds: number;
  durationSeconds: number;
}
