import { skipHydrate } from "pinia";
import type { UserLogin, UserRegister } from "~/types";

export const useAuthStore = defineStore("auth", () => {
  const user = useLocalStorage("user", {});

  async function logIn(_user: UserLogin) {
    // make API call
    user.value = _user;
    return true;
  }

  async function register(user: UserRegister) {
    // make API call
    return true;
  }

  function logOut() {
    user.value = null;
  }

  return {
    user: skipHydrate(user),
    logIn,
    register,
    logOut,
  };
});
