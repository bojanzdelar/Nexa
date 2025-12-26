<template>
  <div>
    <div
      class="flex h-screen w-screen bg-black md:items-center md:justify-center"
    >
      <NuxtImg
        src="/background.jpg"
        class="absolute w-full h-full object-cover opacity-25 !hidden md:!inline"
        alt="Background"
        format="webp"
        quality="80"
      />

      <NuxtLink to="/">
        <NuxtImg
          src="/logo.svg"
          class="absolute left-4 top-4 cursor-pointer object-contain md:left-10 md:top-6"
          width="100"
          alt="Nexa Logo"
      /></NuxtLink>

      <slot />
    </div>
  </div>
</template>
