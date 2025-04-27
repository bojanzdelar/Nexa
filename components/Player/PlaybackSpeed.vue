<script setup lang="ts">
const speeds = [0.5, 0.75, 1, 1.25, 1.5];
defineProps<{
  current: number;
}>();
const emit = defineEmits<{
  (e: "change", speed: number): void;
}>();
</script>

<template>
  <div
    class="absolute bottom-full right-0 bg-neutral-800 rounded shadow-lg w-80 sm:w-[32rem] xl:w-[48rem]"
  >
    <div
      class="text-white text-sm lg:text-base xl:text-xl px-5 py-3 font-semibold mb-2"
    >
      Playback Speed
    </div>
    <div class="p-10">
      <div class="relative">
        <div
          class="absolute top-0 w-full h-0.5 bg-neutral-600 -translate-y-1/2"
        ></div>

        <div class="relative w-full h-full flex justify-between items-center">
          <button
            v-for="speed in speeds"
            :key="speed"
            class="flex flex-col items-center justify-center h-full relative"
            @click="emit('change', speed)"
          >
            <div
              v-if="current === speed"
              class="rounded-full border-2 border-white w-10 h-10 absolute top-0 -translate-y-1/2 transition-all"
            ></div>

            <div
              class="rounded-full absolute top-0 -translate-y-1/2 transition-all"
              :class="
                current === speed
                  ? 'w-5 h-5 bg-white'
                  : 'w-3 h-3 bg-neutral-400 hover:bg-white'
              "
            ></div>

            <div
              class="text-sm lg:text-base xl:text-xl transition-all mt-8"
              :class="
                current === speed
                  ? 'text-white font-medium'
                  : 'text-neutral-400'
              "
            >
              <span>{{ speed }}x</span>
            </div>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
