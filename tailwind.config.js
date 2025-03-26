/** @type {import('tailwindcss').Config} */
export default {
  theme: {
    extend: {
      colors: {
        malachite: "#0bda51",
        "malachite-dark": "#09ae41",
        "malachite-light": "#1ff467",
      },
    },
  },
  content: {
    files: [
      // all directories and extensions will correspond to your Nuxt config
      `${__dirname}/components/**/*.{vue,js,jsx,mjs,ts,tsx}`,
      `${__dirname}/layouts/**/*.{vue,js,jsx,mjs,ts,tsx}`,
      `${__dirname}/pages/**/*.{vue,js,jsx,mjs,ts,tsx}`,
      `${__dirname}/plugins/**/*.{js,ts,mjs}`,
      `${__dirname}/composables/**/*.{js,ts,mjs}`,
      `${__dirname}/utils/**/*.{js,ts,mjs}`,
      `${__dirname}/{A,a}pp.{vue,js,jsx,mjs,ts,tsx}`,
      `${__dirname}/{E,e}rror.{vue,js,jsx,mjs,ts,tsx}`,
      `${__dirname}/app.config.{js,ts,mjs}`,
      `${__dirname}/app/spa-loading-template.html`,
    ],
  },
  plugins: [
    require("tailwindcss-textshadow"),
    require("tailwind-scrollbar-hide"),
  ],
};
