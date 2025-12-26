import { useAuthStore } from "~/store";

export default defineNuxtRouteMiddleware((to) => {
  const authStore = useAuthStore();
  const { isAuthenticated } = storeToRefs(authStore);

  const protectedRoutes = ["/my-list", new RegExp("^/watch")];
  const authRoutes = ["/login", "/register"];

  const isProtectedRoute = protectedRoutes.some((route) => {
    if (typeof route === "string") {
      return to.path === route;
    }
    return route.test(to.path);
  });

  if (isProtectedRoute && !isAuthenticated.value) {
    return navigateTo("/login");
  }

  if (isAuthenticated.value && authRoutes.includes(to.path)) {
    return navigateTo("/");
  }
});
