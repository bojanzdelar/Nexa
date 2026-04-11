<script setup lang="ts">
import Hls from "hls.js";
import {
  getEpisodeProgress,
  getMovieProgress,
  saveEpisodeProgress,
  saveMovieProgress,
  loadAvailableSubtitles,
  loadSubtitle,
} from "~/services";
import type { TitleSummary, Subtitle, SubtitleCue } from "~/types";

const props = defineProps<{
  title: TitleSummary;
  episodeName: string | null;
  season: number | null;
  episode: number | null;
  titleSource: string;
  hasNextEpisode: boolean;
}>();

const emit = defineEmits<{
  (e: "viewDetails" | "nextEpisode"): void;
}>();

let hls: Hls | null = null;
let lastSavedAt = 0;

const videoPlayer = ref<HTMLVideoElement | null>(null);
const playbackSpeedMenu = useTemplateRef<HTMLElement>("playbackSpeedMenu");
const subtitlesMenu = useTemplateRef<HTMLElement>("subtitlesMenu");

const isBuffering = ref(false);
const isPlaying = ref(false);
const currentTime = ref(0);
const duration = ref(0);
const playbackSpeed = ref(1);
const volume = ref(1);
const isMuted = ref(false);
const isFullscreen = ref(false);
const videoAspectRatio = ref(0);

const availableSubtitles = ref<Subtitle[]>([]);
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
  () => props.episodeName,
  () => {
    if (videoPlayer.value) {
      videoPlayer.value.currentTime = 0;
    }
  },
);

watch(subtitle, async (s) => {
  subtitleCues.value = [];
  subtitleText.value = "";

  if (!s) return;

  const vtt = await loadSubtitle(s);
  subtitleCues.value = parseSubtitles(vtt);
});

watch(currentTime, (time, prev = time) => {
  const activeCue = subtitleCues.value.find(
    (cue) => time >= cue.start && time <= cue.end,
  );
  subtitleText.value = activeCue?.text || "";

  if (!isPlaying.value) return;

  const isSeek = Math.abs(time - prev) > 3;

  if (isSeek || time - lastSavedAt >= 15) {
    lastSavedAt = time;
    saveProgress();
  }
});

const onVideoLoaded = async () => {
  if (!videoPlayer.value) return;

  duration.value = videoPlayer.value.duration;
  videoAspectRatio.value =
    videoPlayer.value.videoWidth / videoPlayer.value.videoHeight;
  availableSubtitles.value = await loadAvailableSubtitles(
    props.title,
    props.season ?? undefined,
    props.episode ?? undefined,
  );
  calculateSubtitlePosition();
};

const togglePlay = () => {
  if (!videoPlayer.value) return;

  if (isPlaying.value) {
    videoPlayer.value.pause();
  } else {
    videoPlayer.value.play();
  }

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

  isPlaybackSpeedMenuOpen.value = false;
};

const changeSubtitle = (_subtitle: Subtitle | null) => {
  subtitle.value = _subtitle;

  isSubtitlesMenuOpen.value = false;
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

const toggleFullscreen = async () => {
  if (!videoPlayer.value) return;

  const container = videoPlayer.value.parentNode as HTMLElement;
  const orientation = screen.orientation;

  if (!isFullscreen.value) {
    await container.requestFullscreen();
    orientation.lock?.("landscape")?.catch(() => {});
  } else {
    await document.exitFullscreen();
    orientation.unlock?.();
  }

  isFullscreen.value = !!document.fullscreenElement;
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
      if (document.fullscreenElement) {
        document.exitFullscreen();
      }
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

const fetchProgress = async () => {
  let result;

  if (props.title.type === "tv" && props.season && props.episode) {
    result = await getEpisodeProgress(
      props.title.id,
      props.season,
      props.episode,
    );
  } else {
    result = await getMovieProgress(props.title.id);
  }

  return result?.progressSeconds ?? 0;
};

const resumeProgress = async () => {
  if (!videoPlayer.value) return;

  const progress = await fetchProgress();

  if (progress > 5) {
    videoPlayer.value.currentTime = progress;
  }
};

const saveProgress = async () => {
  if (!videoPlayer.value || duration.value === 0) return;

  const progressSeconds = Math.floor(currentTime.value);
  const durationSeconds = Math.floor(duration.value);

  if (props.title.type === "tv" && props.season && props.episode) {
    await saveEpisodeProgress({
      tvId: props.title.id,
      season: props.season,
      episode: props.episode,
      progressSeconds,
      durationSeconds,
    });
  } else if (props.title.type === "movie") {
    await saveMovieProgress({
      movieId: props.title.id,
      progressSeconds,
      durationSeconds,
    });
  }
};

onMounted(() => {
  if (!videoPlayer.value) return;

  const src = props.titleSource; // .m3u8 master file

  if (Hls.isSupported()) {
    hls = new Hls({
      enableWorker: true,
      lowLatencyMode: false,
      xhrSetup: (xhr) => {
        xhr.withCredentials = true;
      },
    });

    hls.loadSource(src);
    hls.attachMedia(videoPlayer.value);

    hls.on(Hls.Events.MANIFEST_PARSED, () => {
      videoPlayer.value?.play().catch(() => {});
    });
  } else if (videoPlayer.value.canPlayType("application/vnd.apple.mpegurl")) {
    // Safari / iOS
    videoPlayer.value.src = src;
  }

  hideControlsWithDelay();
});

onBeforeUnmount(() => {
  saveProgress();

  if (hls) {
    hls.destroy();
    hls = null;
  }
});

onClickOutside(
  playbackSpeedMenu,
  () => (isPlaybackSpeedMenuOpen.value = false),
);
onClickOutside(subtitlesMenu, () => (isSubtitlesMenuOpen.value = false));

useEventListener("keydown", handleKeypress);
useEventListener("resize", calculateSubtitlePosition);

useEventListener(document, "fullscreenchange", () => {
  isFullscreen.value = !!document.fullscreenElement;
});

useEventListener(videoPlayer, "loadedmetadata", () => {
  resumeProgress();
});

useEventListener(videoPlayer, "waiting", () => {
  isBuffering.value = true;
});

useEventListener(videoPlayer, "canplay", () => {
  isBuffering.value = false;
});

useEventListener(videoPlayer, "playing", () => {
  isBuffering.value = false;
  isPlaying.value = true;
});

useEventListener(videoPlayer, "pause", () => {
  isPlaying.value = false;
  saveProgress();
});

useEventListener(videoPlayer, "ended", () => {
  saveProgress();
});
</script>

<template>
  <div
    class="relative flex items-center justify-center w-screen h-[100dvh] bg-black"
    @mousemove="showControls"
  >
    <video
      ref="videoPlayer"
      class="w-full h-full"
      playsinline
      @timeupdate="updateProgress"
      @canplay="onVideoLoaded"
    />

    <div
      v-if="isBuffering"
      class="absolute inset-0 flex items-center justify-center pointer-events-none"
    >
      <div
        class="w-10 h-10 lg:w-14 lg:h-14 border-4 border-white/30 border-t-white rounded-full animate-spin"
      />
    </div>

    <div
      v-if="subtitleText"
      class="absolute left-1/2 -translate-x-1/2 text-center px-4 py-2 max-w-[80%] text-xl md:text-2xl lg:text-3xl xl:text-4xl"
      :style="{ bottom: `${subtitleBottomPosition}px` }"
    >
      <div
        class="relative bottom-8 lg:bottom-12 xl:bottom-16 drop-shadow-[0_2px_3px_rgba(0,0,0,0.85)]"
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

        <div class="relative flex items-center justify-between">
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
              class="hidden sm:block cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2 hover:scale-125"
              @click="skip(-10)"
            />

            <Icon
              name="heroicons:arrow-uturn-right-solid"
              class="hidden sm:block cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2 hover:scale-125"
              @click="skip(10)"
            />

            <div class="hidden sm:flex items-center">
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
                class="w-8 md:w-12 lg:w-16 xl:w-20 ml-1 opacity-70 hover:opacity-100 accent-malachite"
                @input="updateVolume"
              />
            </div>
          </div>

          <div
            class="absolute text-sm lg:text-base xl:text-xl left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 space-x-2 text-center"
          >
            <div class="font-semibold">{{ title.name }}</div>
            <div v-if="episodeName" class="hidden sm:block">
              {{ episodeName }}
            </div>
          </div>

          <div class="flex items-center space-x-4">
            <Icon
              v-if="title.type === 'tv' && hasNextEpisode"
              name="heroicons:forward-solid"
              class="hidden sm:block cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2"
              @click="emit('nextEpisode')"
            />

            <div ref="playbackSpeedMenu" class="hidden sm:block relative">
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

            <div ref="subtitlesMenu" class="hidden sm:block relative">
              <Icon
                name="heroicons:chat-bubble-bottom-center-text"
                class="cursor-pointer w-6 h-6 md:w-8 md:h-8 lg:w-10 lg:h-10 xl:w-12 xl:h-12 m-1 lg:m-2"
                @click="toggleSubtitlesMenu"
              />

              <PlayerSubtitles
                v-if="isSubtitlesMenuOpen"
                :items="availableSubtitles"
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
