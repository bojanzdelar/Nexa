export const useScrollLock = (locked: Ref<boolean>) => {
  watch(
    locked,
    (val) => {
      if (!import.meta.client) return;

      const value = val ? "hidden" : "";

      document.body.style.overflow = value;
      document.documentElement.style.overflow = value;
    },
    { immediate: true },
  );

  onBeforeUnmount(() => {
    if (!import.meta.client) return;

    document.body.style.overflow = "";
    document.documentElement.style.overflow = "";
  });
};
