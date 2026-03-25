export const useIsStandalone = () => {
  const isStandalone = ref(false);

  onMounted(() => {
    isStandalone.value =
      window.matchMedia("(display-mode: standalone)").matches ||
      // iOS Safari fallback
      window.navigator.standalone === true;
  });

  return { isStandalone };
};
