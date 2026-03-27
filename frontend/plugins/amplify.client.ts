import { Amplify } from "aws-amplify";
import { useAuthStore } from "~/store";

export default defineNuxtPlugin(async () => {
  const config = useRuntimeConfig();

  Amplify.configure({
    Auth: {
      Cognito: {
        userPoolId: config.public.auth.userPoolId,
        userPoolClientId: config.public.auth.clientId,
      },
    },
  });

  const authStore = useAuthStore();
  await authStore.hydrateSession().catch(() => {});
});
