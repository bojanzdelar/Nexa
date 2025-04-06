<script setup lang="ts">
import type { NuxtError } from "#app";

defineProps({
  error: Object as () => NuxtError,
});

const router = useRouter();

const goBack = () => {
  router.back();
};

const reload = () => {
  window.location.reload();
};
</script>

<template>
  <div>
    <Head>
      <title>Nexa</title>
    </Head>

    <BrowseHeader />
    <main class="flex items-center justify-center h-screen">
      <div class="text-center">
        <h1 class="text-xl md:text-3xl lg:text-5xl font-bold mb-4">
          {{ error?.statusMessage }}
        </h1>
        <p class="text-neutral-300 max-w-3xl mx-auto text-lg md:text-xl mb-8">
          Error Code - {{ error?.statusCode }}
        </p>
        <div class="flex gap-3 justify-center">
          <CommonButton icon="arrow-left" text="Go Back" @click="goBack" />

          <NuxtLink to="/">
            <CommonButton
              icon="home"
              text="Home"
              class="!bg-neutral-500/70 text-white"
            />
          </NuxtLink>

          <CommonButton
            v-if="error?.statusCode === 500"
            icon="arrow-path"
            text="Retry"
            class="!bg-neutral-500/70 text-white"
            @click="reload"
          />
        </div>
      </div>
    </main>
  </div>
</template>
