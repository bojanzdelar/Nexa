import type { TitleRef, Subtitle } from "~/types";

export const loadAvailableSubtitles = (
  title: TitleRef,
  season?: number,
  episode?: number,
) => {
  const url =
    title.type === "movie"
      ? `/subtitles/movies/${title.id}`
      : `/subtitles/shows/${title.id}?s=${season}&e=${episode}`;

  return useApiGateway<Subtitle[]>(url);
};

export const loadSubtitle = async (subtitle: Subtitle) => {
  const { url } = await useApiGateway<{ url: string }>("/subtitles/sign", {
    query: { key: subtitle.key },
  });

  return await $fetch<string>(url);
};
