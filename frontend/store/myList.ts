import {
  getMyShows,
  getMyMovies,
  createMyListItem,
  deleteMyListItem,
} from "~/services";
import type { Title, Show, Movie } from "~/types";

export const useMyListStore = defineStore("myList", () => {
  const config = useRuntimeConfig();
  const accountId = Number(config.public.tmdbApiAccountId);

  const myShows = ref<Show[]>([]);
  const myMovies = ref<Movie[]>([]);
  const listsLoaded = ref<boolean>(false);

  onMounted(() => fetchMyList());

  const fetchMyList = async () => {
    const shows = await getMyShows(accountId, false);
    const movies = await getMyMovies(accountId, false);

    myShows.value = shows.results || [];
    myMovies.value = movies.results || [];
    listsLoaded.value = true;
  };

  const isInMyList = (title: Title) => {
    if (title.type === "tv") {
      return myShows.value.some((item) => item.id === title.id);
    }
    return myMovies.value.some((item) => item.id === title.id);
  };

  const addToMyList = async (title: Title) => {
    if (isInMyList(title)) return;
    await createMyListItem(accountId, title, false);

    if (title.type === "tv") {
      myShows.value.push(title as Show);
    } else {
      myMovies.value.push(title as Movie);
    }
  };

  const removeFromMyList = async (title: Title) => {
    await deleteMyListItem(accountId, title, false);

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
