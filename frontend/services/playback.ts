import type { PlaylistTokenResponse, Subtitle } from "~/types";

export const getPlaylistToken = async (path: string) => {
  const proxy = path.replace(/^\/playback\/playlists\//, "");

  return usePlaybackApi<PlaylistTokenResponse>(`/playlists/token/${proxy}`, {
    method: "POST",
  });
};

export const loadAvailableSubtitles = (
  titleType: string,
  titleId: number,
  season?: number,
  episode?: number,
) => {
  const url =
    titleType === "movie"
      ? `/subtitles/movies/${titleId}`
      : `/subtitles/shows/${titleId}?s=${season}&e=${episode}`;

  return usePlaybackApi<Subtitle[]>(url);
};

export const loadSubtitle = async (subtitle: Subtitle) => {
  const config = useRuntimeConfig();
  const url = `${config.public.cdn.baseUrl}/subtitles/${subtitle.key}`;

  return await $fetch<string>(url, {
    credentials: "include",
  });
};
