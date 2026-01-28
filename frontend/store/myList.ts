import { getMyList, createMyListItem, deleteMyListItem } from "~/services";
import { sortByUpdatedDesc } from "~/utils/title";
import type { TitleSummary, Show, Movie } from "~/types";

export const useMyListStore = defineStore("myList", () => {
  const myShows = ref<Show[]>([]);
  const myMovies = ref<Movie[]>([]);
  const listsLoaded = ref<boolean>(false);

  onMounted(() => fetchMyList());

  const fetchMyList = async () => {
    const titles = await getMyList();

    myShows.value = titles
      .filter((t) => t.type === "tv")
      .sort(sortByUpdatedDesc) as Show[];

    myMovies.value = titles
      .filter((t) => t.type === "movie")
      .sort(sortByUpdatedDesc) as Movie[];

    listsLoaded.value = true;
  };

  const isInMyList = (title: TitleSummary) => {
    if (title.type === "tv") {
      return myShows.value.some((item) => item.id === title.id);
    }
    return myMovies.value.some((item) => item.id === title.id);
  };

  const addToMyList = async (title: TitleSummary) => {
    if (isInMyList(title)) return;
    await createMyListItem(title);

    if (title.type === "tv") {
      myShows.value.unshift(title as Show);
    } else {
      myMovies.value.unshift(title as Movie);
    }
  };

  const removeFromMyList = async (title: TitleSummary) => {
    await deleteMyListItem(title);

    if (title.type === "tv") {
      myShows.value = myShows.value.filter((item) => item.id !== title.id);
    } else {
      myMovies.value = myMovies.value.filter((item) => item.id !== title.id);
    }
  };

  return {
    myShows,
    myMovies,
    listsLoaded,
    isInMyList,
    addToMyList,
    removeFromMyList,
    refreshMyList: fetchMyList,
  };
});
