export const useApiDefaults = <T>() => {
  const config = useRuntimeConfig();
  const baseURL = config.public.apiBaseUrl;

  return {
    baseURL,
  };
};
