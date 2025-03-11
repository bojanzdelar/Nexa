<script setup lang="ts">
import { useAuthStore } from "~/store/auth";

const { initialize } = useAuthStore();

onBeforeMount(() => {
  initialize();
});
</script>

<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
