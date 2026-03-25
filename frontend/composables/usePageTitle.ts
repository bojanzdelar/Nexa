export const usePageTitle = (title: string | Ref<string>) => {
  const { isStandalone } = useIsStandalone();

  useHead(() => ({
    title,
    titleTemplate: (t) => {
      if (!t) return "Nexa";
      return isStandalone.value ? t : `${t} - Nexa`;
    },
  }));
};
