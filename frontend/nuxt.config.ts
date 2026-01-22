// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  app: {
    head: {
      title: "Nexa",
      htmlAttrs: {
        lang: "en",
      },
      link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }],
    },
  },
  compatibilityDate: "2024-11-01",
  devtools: { enabled: true },
  typescript: {
    typeCheck: true,
  },
  css: ["~/assets/css/main.css"],
  modules: [
    "@nuxt/eslint",
    "@nuxt/image",
    "@nuxtjs/tailwindcss",
    "@pinia/nuxt",
    "@nuxt/icon",
    "@vueuse/nuxt",
  ],
  routeRules: {
    "/login": { ssr: false },
    "/register": { ssr: false },
    "/my-list": { ssr: false },
    "/watch/**": { ssr: false },
  },
  runtimeConfig: {
    public: {
      cognitoUserPoolId: process.env.NUXT_PUBLIC_COGNITO_USER_POOL_ID,
      cognitoClientId: process.env.NUXT_PUBLIC_COGNITO_CLIENT_ID,
      // TODO: merge when gateway is created
      userApiBaseUrl: process.env.NUXT_PUBLIC_USER_API_BASE_URL,
      catalogApiBaseUrl: process.env.NUXT_PUBLIC_CATALOG_API_BASE_URL,
      tmdbImageBaseUrl: process.env.NUXT_PUBLIC_TMDB_IMAGE_BASE_URL,
    },
  },
});
