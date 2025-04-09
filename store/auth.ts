import { skipHydrate } from "pinia";
import type { UserLogin, UserRegister } from "~/types";

export const useAuthStore = defineStore("auth", () => {
  const user = useLocalStorage("user", {});

  const logIn = async (_user: UserLogin) => {
    // make API call
    user.value = _user;
    return true;
  };

  const register = async (user: UserRegister) => {
    // make API call
    return true;
  };

  const logOut = async () => {
    user.value = null;
  };

  return {
    user: skipHydrate(user),
    logIn,
    register,
    logOut,
  };
});
