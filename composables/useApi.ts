export const useApi = (ssr: boolean) => {
  if (ssr) return useApiForSsr;

  return useApiForCsr;
};
