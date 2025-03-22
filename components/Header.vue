<script setup lang="ts">
const items = [
  { name: "Home", link: "/" },
  { name: "TV Shows", link: "/tv-shows" },
  { name: "Movies", link: "/movies" },
  { name: "New & Popular", link: "/new-popular" },
  { name: "My List", link: "/my-list" },
];

const icons = [
  { name: "Search", source: "heroicons:magnifying-glass-solid" },
  { name: "Notifications", source: "heroicons:bell" },
  { name: "Account", source: "heroicons:user" },
];

const isScrolled = ref(false);

useEventListener("scroll", () => (isScrolled.value = window.scrollY > 0));
</script>

<template>
  <header
    class="fixed top-0 z-50 flex w-full items-center justify-between px-4 py-4 transition-all lg:px-10 lg:py-6"
    :class="{ 'bg-neutral-950': isScrolled }"
  >
    <div class="flex items-center space-x-2 md:space-x-10">
      <NuxtImg
        src="/logo.svg"
        width="80"
        class="cursor-pointer object-contain"
        alt="Nexa Logo"
      />

      <ul class="hidden space-x-4 md:flex">
        <li v-for="item in items" :key="item.name">
          <NuxtLink
            :to="item.link"
            class="cursor-pointer text-sm font-light text-[#e5e5e5] transition duration-200 hover:text-[#b3b3b3]"
            >{{ item.name }}</NuxtLink
          >
        </li>
      </ul>
    </div>

    <div class="flex items-center space-x-4 text-sm font-light">
      <Icon
        v-for="icon in icons"
        :key="icon.name"
        :name="icon.source"
        class="cursor-pointer h-6 w-6 sm:inline"
      />
    </div>
  </header>
</template>
