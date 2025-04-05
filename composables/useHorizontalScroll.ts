export const useHorizontalScroll = () => {
  const row = ref<HTMLElement | null>(null);
  const isMoved = ref(false);

  const handleClick = (direction: string) => {
    if (!row.value) return;

    isMoved.value = true;

    const { scrollLeft, clientWidth } = row.value;

    const scrollTo =
      direction === "left"
        ? scrollLeft - clientWidth
        : scrollLeft + clientWidth;

    row.value.scrollTo({ left: scrollTo, behavior: "smooth" });
  };

  return {
    row,
    isMoved,
    handleClick,
  };
};
