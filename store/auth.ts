import { skipHydrate } from "pinia";
import type { UserLogin } from "~/types";

export const useAuthStore = defineStore("auth", () => {
  const user = useLocalStorage("user", {});

  async function logIn(email: UserLogin) {
    user.value = email;
  }

  function logOut() {
    user.value = null;
  }

  return {
    user: skipHydrate(user),
    logIn,
    logOut,
  };
});
