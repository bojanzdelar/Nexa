<script setup lang="ts">
const items = [
  { name: "Home", link: "/" },
  { name: "TV Shows", link: "/shows" },
  { name: "Movies", link: "/movies" },
  { name: "New & Popular", link: "/latest" },
  { name: "My List", link: "/my-list" },
];

const icons = [
  { name: "Search", source: "heroicons:magnifying-glass-solid" },
  { name: "Notifications", source: "heroicons:bell" },
  { name: "Account", source: "heroicons:user" },
];

const isScrolled = ref(false);

const handleScroll = () => {
  isScrolled.value = window.scrollY > 0;
};

useEventListener("scroll", handleScroll);
</script>

<template>
  <header
    class="fixed top-0 z-10 flex w-full items-center justify-between px-4 transition-all lg:px-10 lg:py-2 bg-gradient-to-b from-neutral-900/50 to-transparent"
    :class="{ 'bg-neutral-900': isScrolled }"
  >
    <div class="flex items-center space-x-2 md:space-x-10">
      <NuxtLink to="/">
        <NuxtImg
          src="/logo.svg"
          width="65"
          class="cursor-pointer object-contain"
          alt="Nexa Logo"
        />
      </NuxtLink>

      <ul class="hidden space-x-4 md:flex">
        <li v-for="item in items" :key="item.name">
          <NuxtLink
            :to="item.link"
            class="cursor-pointer text-sm font-light text-neutral-200 transition duration-200 hover:text-neutral-400"
          >
            {{ item.name }}
          </NuxtLink>
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
