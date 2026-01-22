<script setup lang="ts">
import { useAuthStore } from "~/store";

definePageMeta({
  layout: "auth",
});

const router = useRouter();
const route = useRoute();

const { confirmEmail, resendConfirmationCode } = useAuthStore();

const emailFromQuery = computed(() => {
  const q = route.query.email;
  return typeof q === "string" && q.length > 0 ? q : null;
});

const form = ref({
  email: emailFromQuery.value ?? "",
  code: "",
});

const errors = ref({
  email: false,
  code: false,
});

const serverResponse = ref<string | null>(null);

const isLoading = ref(false);
const isResending = ref(false);

const getErrorMessage = (err: unknown) => {
  const e = err as { name?: string; message?: string };

  if (e?.name === "CodeMismatchException") return "Invalid confirmation code.";
  if (e?.name === "ExpiredCodeException")
    return "Confirmation code expired. Please request a new one.";
  if (e?.name === "UserNotFoundException") return "Account not found.";
  if (e?.name === "NotAuthorizedException")
    return "This account is already confirmed or cannot be confirmed.";
  if (e?.name === "TooManyRequestsException")
    return "Too many attempts. Please try again later.";
  if (e?.name === "InvalidParameterException")
    return "Invalid input. Please check your data.";

  return e?.message ?? "Something went wrong. Please try again.";
};

const confirm = async () => {
  serverResponse.value = null;

  errors.value.email = !form.value.email;
  errors.value.code = !form.value.code || form.value.code.length != 6;

  if (errors.value.email || errors.value.code) return;

  try {
    isLoading.value = true;

    await confirmEmail({
      email: form.value.email,
      code: form.value.code,
    });

    serverResponse.value = "Email confirmed successfully. You can sign in now.";
    await new Promise((resolve) => setTimeout(resolve, 2000));
    router.push("/login");
  } catch (err) {
    serverResponse.value = getErrorMessage(err);
  } finally {
    isLoading.value = false;
  }
};

const resend = async () => {
  serverResponse.value = null;

  errors.value.email = !form.value.email;
  if (errors.value.email) return;

  try {
    isResending.value = true;

    await resendConfirmationCode({
      email: form.value.email,
    });

    serverResponse.value =
      "A new confirmation code has been sent to your email.";
  } catch (err) {
    serverResponse.value = getErrorMessage(err);
  } finally {
    isResending.value = false;
  }
};
</script>

<template>
  <form
    class="z-10 w-full mt-24 space-y-8 rounded bg-black/75 py-10 px-6 md:mt-0 md:max-w-md md:px-14"
    @submit.prevent="confirm"
  >
    <h1 class="text-4xl font-semibold">Confirm Email</h1>

    <p class="text-neutral-400 text-sm">
      Enter the confirmation code we sent to your email.
    </p>

    <p
      v-if="serverResponse"
      class="rounded bg-malachite/20 px-4 py-3 text-sm text-malachite"
    >
      {{ serverResponse }}
    </p>

    <div class="space-y-4">
      <label class="inline-block w-full">
        <input
          v-model="form.email"
          type="email"
          placeholder="Email"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700 disabled:opacity-60"
          :disabled="!!emailFromQuery"
        />
        <p v-if="errors.email" class="p-1 text-sm font-light text-malachite">
          Please enter a valid email.
        </p>
      </label>

      <label class="inline-block w-full">
        <input
          v-model="form.code"
          type="text"
          inputmode="numeric"
          placeholder="Confirmation code"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />
        <p v-if="errors.code" class="p-1 text-sm font-light text-malachite">
          Please enter your six-digit confirmation code.
        </p>
      </label>
    </div>

    <button
      type="submit"
      class="w-full rounded bg-malachite py-3 font-semibold disabled:opacity-60"
      :disabled="isLoading"
    >
      {{ isLoading ? "Confirming..." : "Confirm Email" }}
    </button>

    <button
      type="button"
      class="w-full rounded bg-neutral-800 py-3 font-semibold disabled:opacity-60 hover:bg-neutral-700"
      :disabled="isResending"
      @click="resend"
    >
      {{ isResending ? "Sending..." : "Resend code" }}
    </button>

    <div class="text-neutral-500">
      Already confirmed?
      <NuxtLink to="/login" class="text-white hover:underline">
        Sign in
      </NuxtLink>
    </div>
  </form>
</template>
