<script setup lang="ts">
const route = useRoute();

const { isMobileLandscape } = useMobileOrientation();

const isPlayerPage = computed(() => route.path.includes("watch"));

const shouldRotate = computed(
  () => isMobileLandscape.value && !isPlayerPage.value,
);

useScrollLock(shouldRotate);
</script>

<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>

  <CommonOrientationOverlay
    v-if="shouldRotate"
    message="This app is designed for portrait mode"
  />
</template>
