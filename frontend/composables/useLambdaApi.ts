import { defu } from "defu";
import type { NitroFetchOptions, NitroFetchRequest } from "nitropack";

export const useLambdaApi = async <T>(
  url: string,
  options?: NitroFetchOptions<NitroFetchRequest>,
) => {
  const config = useRuntimeConfig();
  const defaultOptions = useApiDefaults(config.public.api.lambdaBaseUrl);
  const mergedOptions = defu(options, defaultOptions);

  return $fetch<T>(url, mergedOptions);
};
