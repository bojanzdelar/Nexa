<script setup lang="ts">
import { useMyListStore } from "~/store";

const myListStore = useMyListStore();
const { myShows, myMovies } = storeToRefs(myListStore);
</script>

<template>
  <div>
    <Head>
      <title>My List - Nexa</title>
    </Head>

    <main class="pl-4 lg:pl-16 pt-24 md:pt-32 pb-24">
      <section class="space-y-5 md:space-y-10">
        <CommonGroup
          type="content"
          title="My Shows"
          :content="myShows"
          empty="You haven't added any show to your list yet."
        />
        <CommonGroup
          type="content"
          title="My Movies"
          :content="myMovies"
          empty="You haven't added any movie to your list yet."
        />
      </section>
    </main>
  </div>
</template>
