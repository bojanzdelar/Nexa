import type { UserLogin } from "~/types";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: {} as UserLogin | null,
    token: "" as string | null,
  }),
  actions: {
    initialize() {
      this.user = JSON.parse(localStorage.getItem("user") || "{}");
      this.token = localStorage.getItem("token") || "";
    },
    async logIn(user: UserLogin) {
      this.user = user;
      this.token = "soon-to-be-token";
      localStorage.setItem("user", JSON.stringify(this.user));
      localStorage.setItem("token", this.token);
    },
    logOut() {
      this.user = null;
      this.token = null;
      localStorage.removeItem("user");
      localStorage.removeItem("token");
    },
  },
});
