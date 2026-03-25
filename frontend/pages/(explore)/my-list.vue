<script setup lang="ts">
import { useMyListStore } from "~/store";

usePageTitle("My List");

const myListStore = useMyListStore();
const { myShows, myMovies } = storeToRefs(myListStore);
</script>

<template>
  <main class="pl-4 lg:pl-16 pt-24 md:pt-32 pb-24">
    <section class="space-y-5 md:space-y-10">
      <CommonGroup
        type="titles"
        name="My Shows"
        :content="myShows"
        empty="You haven't added any show to your list yet."
      />
      <CommonGroup
        type="titles"
        name="My Movies"
        :content="myMovies"
        empty="You haven't added any movie to your list yet."
      />
    </section>
  </main>
</template>
