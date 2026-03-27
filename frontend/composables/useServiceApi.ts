export const useServiceApi = (ssr: boolean) => {
  if (ssr) return useServiceApiForSsr;

  return useServiceApiForCsr;
};
