import type { FetchContext, FetchResponse } from "ofetch";
import { useAuthStore } from "~/store";

export const useApiDefaults = <T>(baseURL: string) => {
  return {
    baseURL,

    async onRequest({ options }: FetchContext) {
      const auth = useAuthStore();
      const token = await auth.getAccessToken();

      if (token) {
        options.headers = new Headers(options.headers);
        options.headers.set("Authorization", `Bearer ${token}`);
      }
    },

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
