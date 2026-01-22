import { skipHydrate } from "pinia";
import {
  signIn,
  confirmSignUp,
  resendSignUpCode,
  signUp,
  fetchAuthSession,
  signOut,
  getCurrentUser,
} from "aws-amplify/auth";
import type {
  User,
  UserLoginRequest,
  UserRegisterRequest,
  ConfirmEmailRequest,
  ResendConfirmationCodeRequest,
} from "~/types/auth.types";

export const useAuthStore = defineStore("auth", () => {
  const user = ref<User | null>(null);

  const isAuthenticated = computed(() => !!user.value);

  const normalizeEmail = (email: string) => email.trim().toLowerCase();

  const register = async (payload: UserRegisterRequest) => {
    await signUp({
      username: normalizeEmail(payload.email),
      password: payload.password,
      options: {
        userAttributes: {
          email: payload.email,
          given_name: payload.firstName,
          family_name: payload.lastName,
        },
      },
    });
  };

  const confirmEmail = async (payload: ConfirmEmailRequest) => {
    await confirmSignUp({
      username: normalizeEmail(payload.email),
      confirmationCode: payload.code,
    });
  };

  const resendConfirmationCode = async (
    payload: ResendConfirmationCodeRequest,
  ) => {
    await resendSignUpCode({
      username: payload.email,
    });
  };

  const logIn = async (payload: UserLoginRequest) => {
    await signOut({ global: false }).catch(() => {});

    await signIn({
      username: normalizeEmail(payload.email),
      password: payload.password,
    });

    await hydrateSession();
  };

  const hydrateSession = async () => {
    const currentUser = await getCurrentUser();
    const session = await fetchAuthSession();
    const idClaims = session.tokens?.idToken?.payload;

    user.value = {
      id: currentUser.userId,
      email: currentUser.signInDetails?.loginId ?? "",
      firstName: (idClaims?.given_name as string) ?? "",
      lastName: (idClaims?.family_name as string) ?? "",
    };
  };

  const logOut = async () => {
    await signOut();
    user.value = null;
  };

  return {
    user: skipHydrate(user),
    isAuthenticated,
    register,
    confirmEmail,
    resendConfirmationCode,
    logIn,
    logOut,
    hydrateSession,
  };
});
