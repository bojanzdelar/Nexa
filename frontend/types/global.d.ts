export {};

declare global {
  interface ScreenOrientation {
    lock?(orientation: "landscape" | "portrait"): Promise<void>;
    unlock?(): void;
  }

  interface Navigator {
    standalone?: boolean;
  }
}
