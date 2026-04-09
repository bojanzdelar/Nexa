// https://nuxt.com/docs/api/configuration/nuxt-config

export default defineNuxtConfig({
  app: {
    head: {
      title: "Nexa",
      htmlAttrs: {
        lang: "en",
      },
      link: [
        { rel: "icon", type: "image/x-icon", href: "/images/favicon.ico" },
        { rel: "apple-touch-icon", href: "/images/apple-touch-icon.png" },
        { rel: "manifest", href: "/manifest.webmanifest" },
      ],
      meta: [{ name: "theme-color", content: "#000000" }],
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
    "@nuxtjs/tailwindcss",
    "@pinia/nuxt",
    "@nuxt/icon",
    "@vueuse/nuxt",
    "@vite-pwa/nuxt",
  ],
  routeRules: {
    "/login": { ssr: false },
    "/register": { ssr: false },
    "/my-list": { ssr: false },
    "/watch/**": { ssr: false },

    "/api/titles/**": {
      proxy: "http://localhost:8080/titles/**",
    },
    "/api/tv/**": {
      proxy: "http://localhost:8080/tv/**",
    },
    "/api/movies/**": {
      proxy: "http://localhost:8080/movies/**",
    },
    "/api/search": {
      proxy: "http://localhost:8081/search",
    },
    "/api/search/**": {
      proxy: "http://localhost:8081/search/**",
    },
    "/api/me/**": {
      proxy: "http://localhost:8082/me/**",
    },
  },
  pwa: {
    manifest: {
      name: "Nexa",
      short_name: "Nexa",
      theme_color: "#000000",
      background_color: "#000000",
      display: "standalone",
      icons: [
        {
          src: "/images/pwa-192x192.png",
          sizes: "192x192",
          type: "image/png",
        },
        {
          src: "/images/pwa-512x512.png",
          sizes: "512x512",
          type: "image/png",
        },
      ],
    },
  },
  runtimeConfig: {
    public: {
      auth: {
        userPoolId: process.env.NUXT_PUBLIC_COGNITO_USER_POOL_ID,
        clientId: process.env.NUXT_PUBLIC_COGNITO_CLIENT_ID,
      },
      api: {
        baseUrl: process.env.NUXT_PUBLIC_API_BASE_URL,
      },
      playback: {
        baseUrl: process.env.NUXT_PUBLIC_PLAYBACK_BASE_URL,
      },
      cdn: {
        baseUrl: process.env.NUXT_PUBLIC_CDN_BASE_URL,
      },
    },
  },
  vite: {
    server: {
      allowedHosts: true,
    },
  },
});
