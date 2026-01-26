import type { FetchContext, FetchResponse } from "ofetch";

export const useApiDefaults = <T>(baseURL: string) => {
  return {
    baseURL,
    onResponseError: ({
      response,
    }: FetchContext & { response: FetchResponse<T> }) => {
      throw {
        status: response.status,
        message: response._data?.message || "API request failed",
        data: response._data,
      };
    },
  };
};
