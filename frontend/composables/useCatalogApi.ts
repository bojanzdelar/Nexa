export const useCatalogApi = (ssr: boolean) => {
  if (ssr) return useCatalogApiForSsr;

  return useCatalogApiForCsr;
};
