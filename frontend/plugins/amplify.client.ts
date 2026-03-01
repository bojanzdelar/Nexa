import { Amplify } from "aws-amplify";
import { useAuthStore } from "~/store";

export default defineNuxtPlugin(async () => {
  const config = useRuntimeConfig();

  Amplify.configure({
    Auth: {
      Cognito: {
        userPoolId: config.public.cognitoUserPoolId,
        userPoolClientId: config.public.cognitoClientId,
      },
    },
  });

  const authStore = useAuthStore();
  await authStore.hydrateSession().catch(() => {});
});
