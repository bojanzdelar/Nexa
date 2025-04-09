export const useHorizontalScroll = () => {
  const row = ref<HTMLElement | null>(null);
  const isMoved = ref(false);
  const isOverflowed = ref(false);

  onMounted(() => checkOverflow());

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

  const checkOverflow = () => {
    if (!row.value) return;

    isOverflowed.value = row.value.scrollWidth > row.value.clientWidth;
  };

  useEventListener("resize", checkOverflow);

  return {
    row,
    isMoved,
    isOverflowed,
    handleClick,
  };
};
