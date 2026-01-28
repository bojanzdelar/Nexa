<script setup lang="ts">
import type { TitleSummary, Cast } from "~/types";

const props = defineProps<{
  type: "cast" | "titles";
  name: string;
  content: (TitleSummary | Cast)[];
  empty?: string;
}>();

const row = ref<HTMLElement | null>(null);
const isMoved = ref(false);
const isOverflowed = ref(false);

const filteredContent = computed(() => {
  if (props.type === "cast") {
    return (props.content as Cast[]).filter((c) => c.profilePath);
  } else {
    return (props.content as TitleSummary[]).filter((c) => c.posterPath);
  }
});

const emptyMessage = computed(() => {
  return (
    props.empty ||
    (props.type === "cast"
      ? "No cast is found for this title."
      : "There are no titles in this category.")
  );
});

onMounted(() => checkOverflow());

const checkOverflow = () => {
  if (!row.value) return;

  isOverflowed.value = row.value.scrollWidth > row.value.clientWidth;
};

const handleClick = (direction: string) => {
  if (!row.value) return;

  isMoved.value = true;

  const { scrollLeft, clientWidth } = row.value;

  const scrollTo =
    direction === "left" ? scrollLeft - clientWidth : scrollLeft + clientWidth;

  row.value.scrollTo({ left: scrollTo, behavior: "smooth" });
};

useEventListener("resize", checkOverflow);
</script>

<template>
  <div class="relative space-y-2">
    <h2
      class="text-lg font-semibold text-neutral-200 md:text-2xl text-shadow-md cursor-pointer transition hover:text-white"
    >
      {{ name }}
    </h2>
    <div v-if="content.length" class="md:-ml-2">
      <Icon
        name="heroicons:chevron-left"
        class="absolute top-0 bottom-0 left-2 z-10 m-auto h-9 w-9 cursor-pointer transition hover:scale-125"
        :class="{ hidden: !isMoved }"
        @click="handleClick('left')"
      />
      <div
        ref="row"
        class="flex items-start overflow-x-scroll scrollbar-hide space-x-2.5 md:p-2"
      >
        <template v-if="type === 'cast'">
          <CastThumbnail
            v-for="person in filteredContent"
            :key="person.id"
            :person="person as Cast"
          />
        </template>
        <template v-else>
          <TitleThumbnail
            v-for="title in filteredContent"
            :key="title.id"
            :title="title as TitleSummary"
          />
        </template>
      </div>
      <Icon
        name="heroicons:chevron-right"
        class="absolute top-0 bottom-0 right-2 z-10 m-auto h-9 w-9 cursor-pointer transition hover:scale-125"
        :class="{ hidden: !isOverflowed }"
        @click="handleClick('right')"
      />
    </div>
    <div v-else class="py-16">
      <p class="text-neutral-500">{{ emptyMessage }}</p>
    </div>
  </div>
</template>
