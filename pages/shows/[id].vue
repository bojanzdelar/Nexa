<script setup lang="ts">
const route = useRoute();

const showId = route.params.id;
</script>

<template>
  <div>{{ showId }}</div>
</template>
