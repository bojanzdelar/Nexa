import type { Router, RouteLocationNormalized } from "vue-router";

export default defineNuxtPlugin((nuxtApp) => {
  const isSnapshot = (window as any).__SNAPSHOT__;
  if (!isSnapshot) return;

  const router = nuxtApp.$router as Router;

  router.beforeEach(
    (to: RouteLocationNormalized, from: RouteLocationNormalized) => {
      if (to.path !== from.path) {
        window.location.href = to.fullPath;
        return;
      }
    },
  );
});
