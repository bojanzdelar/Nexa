export const useMobileOrientation = () => {
  const isMobileLandscape = ref(false);
  const isMobilePortrait = ref(false);

  const check = () => {
    const width = window.innerWidth;
    const height = window.innerHeight;

    const aspectRatio = width / height;
    const isSmallScreen = width < 1024;

    const isUltraWide = aspectRatio > 1.6;
    const isUltraTall = aspectRatio < 1 / 1.6;

    isMobileLandscape.value = isSmallScreen && isUltraWide;
    isMobilePortrait.value = isSmallScreen && isUltraTall;
  };

  onMounted(() => {
    check();
    window.addEventListener("resize", check);
  });

  onBeforeUnmount(() => {
    window.removeEventListener("resize", check);
  });

  return { isMobileLandscape, isMobilePortrait };
};
