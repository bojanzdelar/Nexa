// https://nuxt.com/docs/api/configuration/nuxt-config

export default defineNuxtConfig({
  app: {
    head: {
      title: "Nexa",
      htmlAttrs: {
        lang: "en",
      },
      link: [
        { rel: "icon", type: "image/x-icon", href: "/favicon.ico" },
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
    "@nuxt/image",
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
          src: "/pwa-192x192.png",
          sizes: "192x192",
          type: "image/png",
        },
        {
          src: "/pwa-512x512.png",
          sizes: "512x512",
          type: "image/png",
        },
      ],
    },
  },
  runtimeConfig: {
    public: {
      cognitoUserPoolId: process.env.NUXT_PUBLIC_COGNITO_USER_POOL_ID,
      cognitoClientId: process.env.NUXT_PUBLIC_COGNITO_CLIENT_ID,
      // TODO: merge when gateway is created
      catalogApiBaseUrl: process.env.NUXT_PUBLIC_CATALOG_API_BASE_URL,
      searchApiBaseUrl: process.env.NUXT_PUBLIC_SEARCH_API_BASE_URL,
      userApiBaseUrl: process.env.NUXT_PUBLIC_USER_API_BASE_URL,
      apiGatewayBaseUrl: process.env.NUXT_PUBLIC_API_GATEWAY_BASE_URL,
      cdnBaseUrl: process.env.NUXT_PUBLIC_CDN_BASE_URL,
    },
  },
  devServer: {
    host: "0.0.0.0",
  },
});
