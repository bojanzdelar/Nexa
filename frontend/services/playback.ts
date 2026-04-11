import type { PlaylistTokenResponse, TitleRef, Subtitle } from "~/types";

export const getPlaylistToken = async (path: string) => {
  const proxy = path.replace(/^\/playlists\//, "");

  return usePlaybackApi<PlaylistTokenResponse>(`/playlists/token/${proxy}`, {
    method: "POST",
  });
};

export const loadAvailableSubtitles = (
  title: TitleRef,
  season?: number,
  episode?: number,
) => {
  const url =
    title.type === "movie"
      ? `/subtitles/movies/${title.id}`
      : `/subtitles/shows/${title.id}?s=${season}&e=${episode}`;

  return usePlaybackApi<Subtitle[]>(url);
};

export const loadSubtitle = async (subtitle: Subtitle) => {
  const config = useRuntimeConfig();
  const url = `${config.public.cdn.baseUrl}/subtitles/${subtitle.key}`;

  return await $fetch<string>(url, {
    credentials: "include",
  });
};
