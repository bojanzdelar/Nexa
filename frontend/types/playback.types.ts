export interface PlaylistTokenResponse {
  token: string;
}

export interface Subtitle {
  code: string;
  label: string;
  key: string;
}

export interface SubtitleCue {
  start: number;
  end: number;
  text: string;
}
