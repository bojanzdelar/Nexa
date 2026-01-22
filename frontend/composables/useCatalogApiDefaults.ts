import type { FetchContext, FetchResponse } from "ofetch";

export const useCatalogApiDefaults = <T>() => {
  const config = useRuntimeConfig();

  return {
    baseURL: config.public.catalogApiBaseUrl,

    onResponseError: ({
      response,
    }: FetchContext & { response: FetchResponse<T> }) => {
      throw {
        status: response.status,
        message: response._data?.message || "Catalog request failed",
        data: response._data,
      };
    },
  };
};
