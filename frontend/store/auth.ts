import { skipHydrate } from "pinia";
import type { UserLogin, UserRegister } from "~/types";

export const useAuthStore = defineStore("auth", () => {
  const user = useLocalStorage("user", {});

  const isAuthenticated = computed(
    () => !!user.value && Object.keys(user.value).length > 0
  );

  const logIn = async (_user: UserLogin) => {
    // make API call
    user.value = _user;
    return true;
  };

  const logOut = async () => {
    user.value = null;
  };

  const register = async (user: UserRegister) => {
    // make API call
    return true;
  };

  return {
    user: skipHydrate(user),
    isAuthenticated,
    logIn,
    logOut,
    register,
  };
});
