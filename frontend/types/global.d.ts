export {};

declare global {
  interface ScreenOrientation {
    lock?(orientation: "landscape" | "portrait");
    unlock?(): void;
  }

  interface Navigator {
    standalone?: boolean;
  }
}
