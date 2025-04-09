import { defu } from "defu";
import type { NitroFetchOptions, NitroFetchRequest } from "nitropack";

export const useApi = async <T>(
  url: string,
  options?: NitroFetchOptions<NitroFetchRequest>
) => {
  const defaultOptions = useApiDefaults();
  const mergedOptions = defu(options, defaultOptions);
  return $fetch<T>(url, mergedOptions);
};
