import { defu } from "defu";
import type { NitroFetchOptions, NitroFetchRequest } from "nitropack";

export const useCatalogApiForCsr = async <T>(
  url: string,
  options?: NitroFetchOptions<NitroFetchRequest>
) => {
  const defaultOptions = useCatalogApiDefaults();
  const mergedOptions = defu(options, defaultOptions);

  return $fetch<T>(url, mergedOptions);
};
