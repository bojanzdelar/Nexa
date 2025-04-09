import {
  getMyShows,
  getMyMovies,
  createMyListItem,
  deleteMyListItem,
} from "~/services";
import type { Show, Movie } from "~/types";

export const useMyListStore = defineStore("myList", () => {
  const config = useRuntimeConfig();
  const accountId = config.public.tmdbApiAccountId;

  const myShows = ref<Show[]>([]);
  const myMovies = ref<Movie[]>([]);
  const listsLoaded = ref<boolean>(false);

  onMounted(() => fetchMyList());

  const fetchMyList = async () => {
    const shows = await getMyShows(Number(accountId));
    const movies = await getMyMovies(Number(accountId));

    myShows.value = shows.results || [];
    myMovies.value = movies.results || [];
    listsLoaded.value = true;

    console.log(myShows.value);
  };

  const isInMyList = (content: Show | Movie) => {
    if (getContentType(content).isShow) {
      return myShows.value.some((item) => item.id === content.id);
    }
    return myMovies.value.some((item) => item.id === content.id);
  };

  const addToMyList = async (content: Show | Movie) => {
    if (isInMyList(content)) return;
    await createMyListItem(Number(accountId), content);

    if (getContentType(content).isShow) {
      myShows.value.push(content as Show);
    } else {
      myMovies.value.push(content as Movie);
    }
  };

  const removeFromMyList = async (content: Show | Movie) => {
    await deleteMyListItem(Number(accountId), content);

    if (getContentType(content).isShow) {
      myShows.value = myShows.value.filter((item) => item.id !== content.id);
    } else {
      myMovies.value = myMovies.value.filter((item) => item.id !== content.id);
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
