<script setup lang="ts">
import { useAuthStore } from "~/store";

const itemsExplore = [
  { name: "Home", link: "/" },
  { name: "TV Shows", link: "/shows" },
  { name: "Movies", link: "/movies" },
  { name: "New & Popular", link: "/latest" },
  { name: "My List", link: "/my-list" },
  { name: "Browse", link: "/browse" },
];

const authStore = useAuthStore();
const { isAuthenticated } = storeToRefs(authStore);
const { logOut } = authStore;

const minMobileWidth = 768;
const { width } = useWindowSize();

const mobileMenu = useTemplateRef<HTMLElement>("mobileMenu");
const userMenu = useTemplateRef<HTMLElement>("userMenu");

const isScrolled = ref(false);
const isMobileMenuOpen = ref(false);
const isUserMenuOpen = ref(false);

watch(width, (newWidth) => {
  if (newWidth >= minMobileWidth && isMobileMenuOpen.value) {
    toggleMobileMenu();
  } else if (newWidth <= minMobileWidth && isUserMenuOpen.value) {
    toggleUserMenu();
  }
});

const handleScroll = () => {
  isScrolled.value = window.scrollY > 0;
};

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value;
};

const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value;
};

onClickOutside(mobileMenu, () => (isMobileMenuOpen.value = false));
onClickOutside(userMenu, () => (isUserMenuOpen.value = false));

useEventListener("scroll", handleScroll);
</script>

<template>
  <header
    class="fixed top-0 z-10 flex w-full items-center justify-between px-4 transition-all lg:px-10 lg:py-2 bg-gradient-to-b from-neutral-900/50 to-transparent"
    :class="{ 'bg-neutral-900': isScrolled }"
  >
    <div class="flex items-center space-x-4 md:space-x-10">
      <div v-if="width < minMobileWidth" class="flex items-center">
        <Icon
          name="heroicons:bars-3"
          class="cursor-pointer h-8 w-8"
          @click="toggleMobileMenu"
        />
      </div>
      <NuxtLink to="/">
        <NuxtImg
          src="/logo.svg"
          width="65"
          class="cursor-pointer object-contain"
          alt="Nexa Logo"
        />
      </NuxtLink>
      <ul class="hidden space-x-4 md:flex">
        <li v-for="item in itemsExplore" :key="item.name">
          <NuxtLink
            :to="item.link"
            class="cursor-pointer text-neutral-200 transition duration-200 hover:text-neutral-400"
          >
            {{ item.name }}
          </NuxtLink>
        </li>
      </ul>
    </div>

    <div class="relative">
      <Icon
        name="heroicons:user"
        class="cursor-pointer h-6 w-6 hidden md:block"
        @click="toggleUserMenu"
      />

      <div
        v-if="isUserMenuOpen"
        ref="userMenu"
        class="absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-neutral-800 py-1"
      >
        <template v-if="isAuthenticated">
          <button
            class="block w-full text-left px-4 py-2 hover:bg-neutral-700"
            @click="
              logOut();
              isUserMenuOpen = false;
            "
          >
            Sign out
          </button>
        </template>
        <template v-else>
          <NuxtLink
            to="/login"
            class="block px-4 py-2 hover:bg-neutral-700"
            @click="isUserMenuOpen = false"
          >
            Sign in
          </NuxtLink>
          <NuxtLink
            to="/register"
            class="block px-4 py-2 hover:bg-neutral-700"
            @click="isUserMenuOpen = false"
          >
            Sign up
          </NuxtLink>
        </template>
      </div>
    </div>
  </header>

  <div
    v-if="isMobileMenuOpen"
    ref="mobileMenu"
    class="fixed top-0 left-0 h-full w-64 bg-neutral-900 z-50 shadow-lg transform transition-transform duration-300 ease-in-out"
  >
    <div
      class="flex justify-between items-center px-2.5 py-4 border-b border-neutral-800"
    >
      <NuxtImg
        src="/logo.svg"
        width="65"
        class="object-contain"
        alt="Nexa Logo"
      />
      <Icon
        name="heroicons:x-mark"
        class="cursor-pointer h-6 w-6"
        @click="toggleMobileMenu"
      />
    </div>
    <ul class="py-4">
      <li v-for="item in itemsExplore" :key="item.name" class="px-4 py-2">
        <NuxtLink
          :to="item.link"
          class="block text-neutral-200 transition duration-200 hover:text-neutral-400"
          @click="isMobileMenuOpen = false"
        >
          {{ item.name }}
        </NuxtLink>
      </li>
      <div class="border-t border-neutral-800 my-4" />

      <li v-if="isAuthenticated" class="px-4 py-2">
        <button
          class="block w-full text-left text-neutral-200 transition duration-200 hover:text-neutral-400"
          @click="
            logOut();
            isMobileMenuOpen = false;
          "
        >
          Sign out
        </button>
      </li>
      <template v-else>
        <li class="px-4 py-2">
          <NuxtLink
            to="/login"
            class="block text-neutral-200 transition duration-200 hover:text-neutral-400"
            @click="isMobileMenuOpen = false"
          >
            Sign in
          </NuxtLink>
        </li>
        <li class="px-4 py-2">
          <NuxtLink
            to="/register"
            class="block text-neutral-200 transition duration-200 hover:text-neutral-400"
            @click="isMobileMenuOpen = false"
          >
            Sign up
          </NuxtLink>
        </li>
      </template>
    </ul>
  </div>

  <div
    v-if="isMobileMenuOpen"
    class="fixed inset-0 bg-black bg-opacity-50 z-40"
    @click="isMobileMenuOpen = false"
  ></div>
</template>
