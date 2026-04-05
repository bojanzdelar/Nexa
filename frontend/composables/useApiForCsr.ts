import { defu } from "defu";
import type { NitroFetchOptions, NitroFetchRequest } from "nitropack";

export const useApiForCsr = async <T>(
  url: string,
  options?: NitroFetchOptions<NitroFetchRequest>,
) => {
  const config = useRuntimeConfig();
  const defaultOptions = useApiDefaults(config.public.api.baseUrl);
  const mergedOptions = defu(options, defaultOptions);

  return $fetch<T>(url, mergedOptions);
};
