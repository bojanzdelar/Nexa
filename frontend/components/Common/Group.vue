<script setup lang="ts">
import type { TitleSummary, ContinueWatchingItem, Cast } from "~/types";

const props = defineProps<{
  type: "titles" | "continue" | "cast";
  name: string;
  content: (TitleSummary | ContinueWatchingItem | Cast)[];
  empty?: string;
}>();

const items = ref<(TitleSummary | ContinueWatchingItem | Cast)[]>([
  ...props.content,
]);

const row = ref<HTMLElement | null>(null);
const isMoved = ref(false);
const isOverflowed = ref(false);

const castItems = computed<Cast[]>(() => {
  if (props.type !== "cast") return [];
  return (items.value as Cast[]).filter((c) => c.profilePath);
});

const continueItems = computed<ContinueWatchingItem[]>(() => {
  if (props.type !== "continue") return [];
  return items.value as ContinueWatchingItem[];
});

const titleItems = computed<TitleSummary[]>(() => {
  if (props.type !== "titles") return [];
  return (items.value as TitleSummary[]).filter((t) => t.posterPath);
});

const emptyMessage = computed(() => {
  if (props.empty) return props.empty;

  switch (props.type) {
    case "cast":
      return "No cast found for this title.";
    case "continue":
      return "You have nothing to continue watching.";
    default:
      return "There are no titles in this category.";
  }
});

watch(
  () => props.content,
  (val) => (items.value = val),
);

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

const onRemoved = (id: number, type: string) => {
  if (props.type !== "continue") return;

  items.value = (items.value as ContinueWatchingItem[]).filter(
    (i) => !(i.id === id && i.type === type),
  );
};

onMounted(() => checkOverflow());

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
            v-for="person in castItems"
            :key="person.id"
            :person="person as Cast"
          />
        </template>

        <template v-else-if="type === 'continue'">
          <TitleWatching
            v-for="item in continueItems"
            :key="`${item.type}-${item.id}`"
            :item="item as ContinueWatchingItem"
            @removed="onRemoved"
          />
        </template>

        <template v-else>
          <TitleThumbnail
            v-for="title in titleItems"
            :key="`${title.type}-${title.id}`"
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
