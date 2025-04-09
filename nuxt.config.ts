// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
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
  runtimeConfig: {
    public: {
      tmdbApiBaseUrl: process.env.TMDB_API_BASE_URL,
      tmdbApiAccountId: process.env.TMDB_API_ACCOUNT_ID, // temporary
      tmdbApiAccessToken: process.env.TMDB_API_ACCESS_TOKEN, // temporary
      tmdbImageBaseUrl: process.env.TMDB_IMAGE_BASE_URL,
    },
  },
});
