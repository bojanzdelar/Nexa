export const handleFatalError = (e: unknown) => {
  if (e instanceof Error) {
    showError(e);
    return;
  }

  showError(
    createError({
      statusCode: 500,
      statusMessage: "Unknown error",
    }),
  );
};
