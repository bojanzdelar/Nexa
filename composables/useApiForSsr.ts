import { defu } from "defu";
import type { UseFetchOptions } from "#app";

export const useApiForSsr = async <T>(
  url: string,
  options?: UseFetchOptions<T>
) => {
  const defaultOptions = useApiDefaults();
  const mergedOptions = defu(options, defaultOptions);
  // useFetch is combination of useAsyncData and $fetch, just a syntatic sugar
  // useAsyncData should be used with SSR to avoid fetching same data twice
  return useFetch(url, mergedOptions);
};
