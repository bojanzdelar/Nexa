<script setup lang="ts">
import type { Subtitle, SubtitleCue } from "~/types";

const props = defineProps<{
  contentType: "tv" | "movie";
  contentId: number;
  contentTitle: string | null;
  episodeTitle: string | null;
  contentSource: string;
  hasNextEpisode: boolean;
}>();

const emit = defineEmits<{
  (e: "viewDetails" | "nextEpisode"): void;
}>();

const videoPlayer = ref<HTMLVideoElement | null>(null);
const playbackSpeedMenu = useTemplateRef<HTMLElement>("playbackSpeedMenu");
const subtitlesMenu = useTemplateRef<HTMLElement>("subtitlesMenu");

const isPlaying = ref(false);
const currentTime = ref(0);
const duration = ref(0);
const playbackSpeed = ref(1);
const volume = ref(1);
const isMuted = ref(false);
const isFullscreen = ref(false);
const videoAspectRatio = ref(0);

const subtitle = ref<Subtitle | null>(null);
const subtitleCues = ref<SubtitleCue[]>([]);
const subtitleText = ref<string>("");
const subtitleBottomPosition = ref(0);

const controlsVisible = ref(true);
const controlsTimeout = ref<number | null>(null);

const isPlaybackSpeedMenuOpen = ref(false);
const isSubtitlesMenuOpen = ref(false);

const progressPercentage = computed(() => {
  return (currentTime.value / duration.value) * 100;
});

const isAnyMenuOpen = computed(() => {
  return isPlaybackSpeedMenuOpen.value || isSubtitlesMenuOpen.value;
});

watch(
  () => props.episodeTitle,
  () => {
    if (videoPlayer.value) {
      videoPlayer.value.currentTime = 0;
    }
  }
);

watch(subtitle, () => {
  subtitleCues.value = [];
  subtitleText.value = "";
  loadSubtitles();
});

watch(currentTime, (time) => {
  const activeCue = subtitleCues.value.find(
    (cue) => time >= cue.start && time <= cue.end
  );

  subtitleText.value = activeCue?.text || "";
});

const onVideoLoaded = () => {
  if (!videoPlayer.value) return;

  duration.value = videoPlayer.value.duration;
  videoAspectRatio.value =
    videoPlayer.value.videoWidth / videoPlayer.value.videoHeight;
  loadSubtitles();
  calculateSubtitlePosition();
};

const togglePlay = () => {
  if (!videoPlayer.value) return;

  if (isPlaying.value) {
    videoPlayer.value.pause();
  } else {
    videoPlayer.value.play();
  }

  isPlaying.value = !isPlaying.value;

  hideControlsWithDelay();
};

const updateProgress = () => {
  if (!videoPlayer.value) return;

  currentTime.value = videoPlayer.value.currentTime;
  duration.value = videoPlayer.value.duration;
};

const formatTime = (seconds: number): string => {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60);
  return `${minutes}:${remainingSeconds < 10 ? "0" : ""}${remainingSeconds}`;
};

const seek = (event: MouseEvent) => {
  if (!videoPlayer.value) return;

  const progressBar = event.currentTarget as HTMLElement;
  const clickPosition = event.offsetX;
  const totalWidth = progressBar.offsetWidth;
  const percentage = clickPosition / totalWidth;

  videoPlayer.value.currentTime = percentage * videoPlayer.value.duration;
};

const skip = (seconds: number) => {
  if (!videoPlayer.value) return;

  videoPlayer.value.currentTime += seconds;
};

const updateVolume = () => {
  if (!videoPlayer.value) return;

  videoPlayer.value.volume = volume.value;
  videoPlayer.value.muted = volume.value === 0;
  isMuted.value = videoPlayer.value.muted;
};

const toggleMute = () => {
  if (!videoPlayer.value) return;

  videoPlayer.value.muted = !videoPlayer.value.muted;
  isMuted.value = videoPlayer.value.muted;
};

const changePlaybackSpeed = (speed: number) => {
  if (!videoPlayer.value) return;

  playbackSpeed.value = speed;
  videoPlayer.value.playbackRate = speed;
};

const changeSubtitle = (_subtitle: Subtitle | null) => {
  subtitle.value = _subtitle;
};

const loadSubtitles = async () => {
  if (!subtitle.value) return;

  const vttContent = await $fetch<string>(
    `/subtitle-${subtitle.value.code}.vtt`
  );

  subtitleCues.value = parseSubtitles(vttContent);
};

const parseSubtitles = (vttContent: string) => {
  return vttContent
    .split("\n")
    .filter((line) => line != "WEBVTT")
    .filter(Boolean)
    .reduce((acc, line) => {
      if (line.includes("-->")) acc.push({ timeCode: line, text: [] });
      else acc[acc.length - 1].text?.push(line);
      return acc;
    }, [] as { timeCode: string; text: string[] }[])
    .map((cue) => {
      const [start, end] = cue.timeCode
        .split("-->")
        .map((time) => parseTimeCode(time.trim()));
      return { start, end, text: cue.text.join("\n") };
    });
};

const parseTimeCode = (timeCode: string): number => {
  const [hours, minutes, secondsPart] = timeCode.split(":");
  const seconds =
    parseInt(hours) * 3600 + parseInt(minutes) * 60 + parseFloat(secondsPart);
  return seconds;
};

const calculateSubtitlePosition = () => {
  const [screenWidth, screenHeight] = [window.innerWidth, window.innerHeight];
  const currentVideoHeight = screenWidth / videoAspectRatio.value;

  if (screenHeight < currentVideoHeight) {
    subtitleBottomPosition.value = 0;
    return;
  }

  subtitleBottomPosition.value = (screenHeight - currentVideoHeight) / 2;
};

const toggleFullscreen = () => {
  if (!videoPlayer.value) return;

  const container = videoPlayer.value.parentNode as HTMLElement;

  if (!isFullscreen.value) {
    container.requestFullscreen();
  } else {
    document.exitFullscreen();
  }

  isFullscreen.value = !isFullscreen.value;
};

const handleKeypress = (event: KeyboardEvent) => {
  const key = event.key.toLowerCase();

  switch (key) {
    case " ":
      togglePlay();
      break;
    case "arrowright":
      skip(10);
      break;
    case "arrowleft":
      skip(-10);
      break;
    case "arrowup":
      volume.value = Math.min(1, volume.value + 0.1);
      updateVolume();
      break;
    case "arrowdown":
      volume.value = Math.max(0, volume.value - 0.1);
      updateVolume();
      break;
    case "m":
      toggleMute();
      break;
    case "f":
      toggleFullscreen();
      break;
    case "escape":
      isFullscreen.value = false;
      break;
  }

  showControls();
};

const showControls = () => {
  controlsVisible.value = true;
  if (controlsTimeout.value !== null) {
    clearTimeout(controlsTimeout.value);
  }

  if (isPlaying.value) {
    hideControlsWithDelay();
  }
};

const hideControlsWithDelay = () => {
  if (controlsTimeout.value !== null) {
    clearTimeout(controlsTimeout.value);
  }

  controlsTimeout.value = window.setTimeout(() => {
    if (isPlaying.value) {
      controlsVisible.value = false;
      isPlaybackSpeedMenuOpen.value = false;
      isSubtitlesMenuOpen.value = false;
    }
  }, 3000);
};

const togglePlaybackSpeedMenu = () => {
  isPlaybackSpeedMenuOpen.value = !isPlaybackSpeedMenuOpen.value;
  if (isPlaybackSpeedMenuOpen.value) {
    isSubtitlesMenuOpen.value = false;
  }
};

const toggleSubtitlesMenu = () => {
  isSubtitlesMenuOpen.value = !isSubtitlesMenuOpen.value;
  if (isSubtitlesMenuOpen.value) {
    isPlaybackSpeedMenuOpen.value = false;
  }
};

onMounted(() => {
  isPlaying.value = !videoPlayer.value?.paused;
  hideControlsWithDelay();
});

onClickOutside(
  playbackSpeedMenu,
  () => (isPlaybackSpeedMenuOpen.value = false)
);
onClickOutside(subtitlesMenu, () => (isSubtitlesMenuOpen.value = false));

useEventListener("keydown", handleKeypress);
useEventListener("resize", calculateSubtitlePosition);
</script>

<template>
  <div
    class="relative flex items-center justify-center w-screen h-screen bg-black"
    @mousemove="showControls"
  >
    <video
      ref="videoPlayer"
      class="w-full h-full"
      autoplay
      @timeupdate="updateProgress"
      @canplay="onVideoLoaded"
    >
      <source :src="contentSource" type="video/mp4" />
      Your browser does not support the video tag.
    </video>

    <div
      v-if="subtitleText"
      class="absolute left-1/2 -translate-x-1/2 text-center px-4 py-2 max-w-[80%] text-xl md:text-2xl lg:text-3xl xl:text-4xl"
      :style="{ bottom: `${subtitleBottomPosition}px` }"
    >
      <div
        class="relative bottom-8 lg:bottom-12 xl:bottom-16"
        :class="{
          'bottom-24 lg:bottom-32 xl:bottom-40':
            controlsVisible && !subtitleBottomPosition,
        }"
      >
        {{ subtitleText }}
      </div>
    </div>

    <div
      class="absolute inset-0 flex flex-col justify-between p-3 lg:p-5 bg-gradient-to-b from-black/70 via-transparent to-black/70 transition-opacity duration-300 pointer-events-none"
      :class="{
        'opacity-0': !controlsVisible && isPlaying,
        'opacity-100 pointer-events-auto': controlsVisible || !isPlaying,
      }"
      @click.self="togglePlay"
    >
      <div
        class="flex items-center justify-between py-3"
        @click.self="togglePlay"
      >
        <NuxtLink to="/">
          <Icon
            name="heroicons:arrow-left-solid"
            class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 m-1 lg:m-2"
          />
        </NuxtLink>

        <Icon
          name="heroicons:list-bullet-solid"
          class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 m-1 lg:m-2"
          @click="emit('viewDetails')"
        />
      </div>

      <div
        v-if="!isPlaying"
        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-12 h-12 lg:w-24 lg:h-24 rounded-full bg-black/60 flex justify-center items-center cursor-pointer"
        @click="togglePlay"
      >
        <Icon
          name="heroicons:play-solid"
          class="w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12"
        />
      </div>

      <div class="w-full">
        <div v-if="!isAnyMenuOpen" class="flex items-center gap-4 mb-4">
          <div
            class="cursor-pointer h-1.5 bg-white/30 relative w-full rounded-sm group flex-1"
            @click="seek"
          >
            <div
              class="absolute h-full bg-malachite rounded-sm group-hover:h-2 group-hover:-translate-y-0.5 transition-all"
              :style="{ width: `${progressPercentage}%` }"
            />
          </div>
          <div class="text-xs md:text-sm lg:text-base">
            {{ formatTime(duration - currentTime) }}
          </div>
        </div>

        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <Icon
              :name="
                isPlaying ? 'heroicons-pause-solid' : 'heroicons:play-solid'
              "
              class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2 hover:scale-125"
              @click="togglePlay"
            />

            <Icon
              name="heroicons:arrow-uturn-left-solid"
              class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2 hover:scale-125"
              @click="skip(-10)"
            />

            <Icon
              name="heroicons:arrow-uturn-right-solid"
              class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2 hover:scale-125"
              @click="skip(10)"
            />

            <div class="flex items-center">
              <Icon
                :name="
                  isMuted
                    ? 'heroicons:speaker-x-mark-solid'
                    : 'heroicons:speaker-wave-solid'
                "
                class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2 hover:scale-125"
                @click="toggleMute"
              />
              <input
                v-model="volume"
                type="range"
                min="0"
                max="1"
                step="0.1"
                class="w-24 ml-1 opacity-70 hover:opacity-100 accent-malachite"
                @input="updateVolume"
              />
            </div>
          </div>

          <div
            class="absolute text-sm lg:text-base xl:text-xl left-1/2 -translate-x-1/2 bottom-5 space-x-2 text-center"
          >
            <div class="font-semibold">{{ contentTitle }}</div>
            <div v-if="episodeTitle" class="font-normal">
              {{ episodeTitle }}
            </div>
          </div>

          <div class="flex items-center space-x-4">
            <Icon
              v-if="contentType === 'tv' && hasNextEpisode"
              name="heroicons:forward-solid"
              class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2"
              @click="emit('nextEpisode')"
            />

            <div ref="playbackSpeedMenu" class="relative">
              <Icon
                name="heroicons:adjustments-horizontal-solid"
                class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2"
                @click="togglePlaybackSpeedMenu"
              />
              <PlayerPlaybackSpeed
                v-if="isPlaybackSpeedMenuOpen"
                :current="playbackSpeed"
                @change="changePlaybackSpeed"
              />
            </div>

            <div ref="subtitlesMenu" class="relative">
              <Icon
                name="heroicons:chat-bubble-bottom-center-text"
                class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2"
                @click="toggleSubtitlesMenu"
              />

              <PlayerSubtitles
                v-if="isSubtitlesMenuOpen"
                :current="subtitle"
                @change="changeSubtitle"
              />
            </div>

            <Icon
              :name="
                isFullscreen
                  ? 'heroicons:arrows-pointing-in-solid'
                  : 'heroicons:arrows-pointing-out-solid'
              "
              class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2"
              @click="toggleFullscreen"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
