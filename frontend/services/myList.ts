import type { TitleRef, TitleSummary } from "~/types";

export const getMyList = async (): Promise<TitleSummary[]> => {
  const refs = await useServiceApi(false)<TitleRef[]>(`/me/watchlist`);
  if (!refs.length) return [];

  const summaries = await useServiceApi(false)<TitleSummary[]>(
    `/titles/batch`,
    {
      method: "POST",
      body: refs.map((r) => ({ id: r.id, type: r.type })),
    },
  );

  const updatedMap = new Map(
    refs.map((r) => [`${r.id}-${r.type}`, r.updatedAt]),
  );

  return summaries.map((s) => ({
    ...s,
    updatedAt: updatedMap.get(`${s.id}-${s.type}`)!,
  }));
};

export const createMyListItem = (title: TitleSummary) => {
  return useServiceApi(false)<object>(
    `/me/watchlist/${title.type}/${title.id}`,
    {
      method: "PUT",
    },
  );
};

export const deleteMyListItem = (title: TitleSummary) => {
  return useServiceApi(false)<object>(
    `/me/watchlist/${title.type}/${title.id}`,
    {
      method: "DELETE",
    },
  );
};
