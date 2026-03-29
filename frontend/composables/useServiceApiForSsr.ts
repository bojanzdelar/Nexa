import { defu } from "defu";
import type { UseFetchOptions } from "#app";

export const useServiceApiForSsr = async <T>(
  url: string,
  options?: UseFetchOptions<T>,
) => {
  const config = useRuntimeConfig();
  const defaultOptions = useApiDefaults(config.public.api.serviceBaseUrl);
  const mergedOptions = defu(options, defaultOptions);

  // useFetch is combination of useAsyncData and $fetch, just a syntatic sugar
  // useAsyncData should be used with SSR to avoid fetching same data twice
  const { data, error } = await useFetch(url, mergedOptions);

  if (error.value) {
    throw error.value;
  }

  return data.value as T;
};
