import { getMyList, createMyListItem, deleteMyListItem } from "~/services";
import { useAuthStore } from "~/store";
import type { TitleSummary, Show, Movie } from "~/types";

export const useMyListStore = defineStore("myList", () => {
  const authStore = useAuthStore();

  const myList = ref<TitleSummary[]>([]);
  const listsLoaded = ref<boolean>(false);

  const myShows = computed(
    () => myList.value.filter((t) => t.type === "tv") as Show[],
  );

  const myMovies = computed(
    () => myList.value.filter((t) => t.type === "movie") as Movie[],
  );

  const fetchMyList = async () => {
    if (!authStore.isAuthenticated || listsLoaded.value) return;

    const titles = await getMyList();

    myList.value = titles.sort(sortByUpdatedDesc);
    listsLoaded.value = true;
  };

  const isInMyList = (title: TitleSummary) => {
    return myList.value.some(
      (item) => item.id === title.id && item.type === title.type,
    );
  };

  const addToMyList = async (title: TitleSummary) => {
    if (isInMyList(title)) return;

    await createMyListItem(title);
    myList.value.unshift(title);
  };

  const removeFromMyList = async (title: TitleSummary) => {
    await deleteMyListItem(title);

    myList.value = myList.value.filter(
      (item) => !(item.id === title.id && item.type === title.type),
    );
  };

  watch(
    () => authStore.isAuthenticated,
    (isAuthenticated) => {
      if (isAuthenticated) {
        fetchMyList();
      } else {
        myList.value = [];
        listsLoaded.value = false;
      }
    },
    { immediate: true },
  );

  return {
    myList,
    myShows,
    myMovies,
    listsLoaded,
    isInMyList,
    addToMyList,
    removeFromMyList,
    refreshMyList: fetchMyList,
  };
});
