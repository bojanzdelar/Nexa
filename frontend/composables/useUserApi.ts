export const useUserApi = () => {
  const config = useRuntimeConfig();

  return $fetch.create({
    baseURL: config.public.userApiBaseUrl,

    onResponseError({ response }) {
      throw {
        response: response,
        status: response.status,
        message: response._data?.message || "User request failed",
        data: response._data,
      };
    },
  });
};
