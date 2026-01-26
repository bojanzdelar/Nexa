import { defu } from "defu";
import type { UseFetchOptions } from "#app";

export const useCatalogApiForSsr = async <T>(
  url: string,
  options?: UseFetchOptions<T>,
) => {
  const config = useRuntimeConfig();
  const defaultOptions = useApiDefaults(config.public.catalogApiBaseUrl);
  const mergedOptions = defu(options, defaultOptions);

  // useFetch is combination of useAsyncData and $fetch, just a syntatic sugar
  // useAsyncData should be used with SSR to avoid fetching same data twice
  const { data } = await useFetch(url, mergedOptions);

  if (!data.value) {
    throw new Error("Something went wrong while fetching data!");
  }

  return data.value;
};
