import type { SubtitleCue } from "~/types";

export const parseTimeCode = (timeCode: string): number =>
  timeCode
    .split(":")
    .map(Number)
    .reduce((acc, value) => acc * 60 + value, 0);

export const parseSubtitles = (vtt: string): SubtitleCue[] =>
  vtt
    .split(/\r?\n\r?\n+/)
    .map((block) => block.trim())
    .filter((block) => block && block !== "WEBVTT")
    .map((block) => {
      const lines = block.split(/\r?\n/);
      const timeLine = lines.find((l) => l.includes("-->"));
      if (!timeLine) return null;

      const [startRaw, endRaw] = timeLine.split("-->").map((s) => s.trim());
      const text = lines.slice(lines.indexOf(timeLine) + 1).join("\n");

      return {
        start: parseTimeCode(startRaw),
        end: parseTimeCode(endRaw),
        text,
      };
    })
    .filter((cue): cue is SubtitleCue => cue !== null);
