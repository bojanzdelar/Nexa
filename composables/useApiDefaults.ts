export const useApiDefaults = <T>() => {
  const config = useRuntimeConfig();
  const baseURL = config.public.tmdbApiBaseUrl;
  const language = "en-US";
  const accessToken = `Bearer ${config.public.tmdbApiAccessToken}`;

  return {
    baseURL,
    query: {
      language,
    },
    headers: {
      Authorization: accessToken,
    },
  };
};
