export const useAPI = <T>(urlSuffix: string) => {
  const config = useRuntimeConfig();

  const url = `${config.public.tmdbApiBaseUrl}${urlSuffix}${
    urlSuffix.includes("?") ? "&" : "?"
  }api_key=${config.public.tmdbApiSecretKey}&language=en-US`;

  return useFetch<T>(url);
};
