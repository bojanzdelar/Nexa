<script setup lang="ts">
import type { Subtitle } from "~/types";

defineProps<{
  current: Subtitle | null;
}>();

const emit = defineEmits<{
  (e: "change", subtitle: Subtitle | null): void;
}>();

const subtitles: Subtitle[] = [
  { code: "en", name: "English" },
  { code: "sr", name: "Serbian" },
];
</script>

<template>
  <div
    class="absolute bottom-full right-0 bg-neutral-800 rounded shadow-lg w-80"
  >
    <div
      class="text-white text-sm lg:text-base xl:text-xl px-5 py-3 font-semibold mb-2"
    >
      Subtitles
    </div>
    <div class="flex flex-col space-y-1">
      <button
        class="text-neutral-300 text-sm lg:text-base xl:text-lg px-5 py-3 rounded hover:bg-white/10 text-left flex justify-between"
        :class="{ '!text-white': !current }"
        @click="emit('change', null)"
      >
        <span>Off</span>
        <Icon
          v-if="!current"
          name="heroicons:check-solid"
          class="w-4 h-4 md:w-5 md:h-5 lg:w-6 lg:h-6"
        />
      </button>

      <button
        v-for="subtitle in subtitles"
        :key="subtitle.code"
        class="text-neutral-300 text-sm lg:text-base xl:text-lg px-5 py-3 rounded hover:bg-white/10 text-left flex justify-between"
        :class="{ '!text-white': current?.code === subtitle.code }"
        @click="emit('change', subtitle)"
      >
        <span>{{ subtitle.name }}</span>
        <Icon
          v-if="current?.code === subtitle.code"
          name="heroicons:check-solid"
          class="w-4 h-4 md:w-5 md:h-5 lg:w-6 lg:h-6"
        />
      </button>
    </div>
  </div>
</template>
