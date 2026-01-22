<script setup lang="ts">
import { useAuthStore } from "~/store";

definePageMeta({
  layout: "auth",
});

const router = useRouter();
const { register } = useAuthStore();

const form = ref({
  email: "",
  password: "",
  confirmPassword: "",
  firstName: "",
  lastName: "",
});

const errors = ref({
  email: false,
  password: false,
  confirmPassword: false,
  firstName: false,
  lastName: false,
});

const serverError = ref<string | null>(null);

const isLoading = ref(false);

const getErrorMessage = (err: unknown) => {
  const e = err as { name?: string; message?: string };

  if (e?.name === "UsernameExistsException")
    return "An account with this email already exists.";
  if (e?.name === "InvalidPasswordException")
    return "Password does not meet requirements.";
  if (e?.name === "InvalidParameterException")
    return "Invalid input. Please check your data.";
  if (e?.name === "TooManyRequestsException")
    return "Too many attempts. Please try again later.";

  return e?.message ?? "Something went wrong. Please try again.";
};

const signUp = async () => {
  serverError.value = null;

  errors.value.email = !form.value.email;

  errors.value.password =
    !form.value.password ||
    form.value.password.length < 8 ||
    form.value.password.length > 60;

  errors.value.confirmPassword =
    !form.value.confirmPassword ||
    form.value.password !== form.value.confirmPassword;

  errors.value.firstName = !form.value.firstName;
  errors.value.lastName = !form.value.lastName;

  if (
    errors.value.email ||
    errors.value.password ||
    errors.value.confirmPassword ||
    errors.value.firstName ||
    errors.value.lastName
  ) {
    return;
  }

  try {
    isLoading.value = true;

    await register({
      email: form.value.email,
      password: form.value.password,
      firstName: form.value.firstName,
      lastName: form.value.lastName,
    });

    router.push(`/confirm-email?email=${encodeURIComponent(form.value.email)}`);
  } catch (err) {
    serverError.value = getErrorMessage(err);
  } finally {
    isLoading.value = false;
  }
};
</script>

<template>
  <form
    class="z-10 w-full mt-24 space-y-8 rounded bg-black/75 py-10 px-6 md:mt-0 md:max-w-md md:px-14"
    @submit.prevent="signUp"
  >
    <h1 class="text-4xl font-semibold">Sign Up</h1>

    <p
      v-if="serverError"
      class="rounded bg-malachite/20 px-4 py-3 text-sm text-malachite"
    >
      {{ serverError }}
    </p>

    <div class="space-y-4">
      <label class="inline-block w-full">
        <input
          v-model="form.firstName"
          type="text"
          placeholder="First name"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />
        <p
          v-if="errors.firstName"
          class="p-1 text-sm font-light text-malachite"
        >
          Please enter your first name.
        </p>
      </label>

      <label class="inline-block w-full">
        <input
          v-model="form.lastName"
          type="text"
          placeholder="Last name"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />
        <p v-if="errors.lastName" class="p-1 text-sm font-light text-malachite">
          Please enter your last name.
        </p>
      </label>

      <label class="inline-block w-full">
        <input
          v-model="form.email"
          type="email"
          placeholder="Email"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />
        <p v-if="errors.email" class="p-1 text-sm font-light text-malachite">
          Please enter a valid email.
        </p>
      </label>

      <label class="inline-block w-full">
        <input
          v-model="form.password"
          type="password"
          placeholder="Password"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />
        <p v-if="errors.password" class="p-1 text-sm font-light text-malachite">
          Your password must contain between 8 and 60 characters.
        </p>
      </label>

      <label class="inline-block w-full">
        <input
          v-model="form.confirmPassword"
          type="password"
          placeholder="Confirm Password"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />
        <p
          v-if="errors.confirmPassword"
          class="p-1 text-sm font-light text-malachite"
        >
          Passwords do not match.
        </p>
      </label>
    </div>

    <button
      type="submit"
      class="w-full rounded bg-malachite py-3 font-semibold disabled:opacity-60"
      :disabled="isLoading"
    >
      {{ isLoading ? "Signing up..." : "Sign Up" }}
    </button>

    <div class="text-neutral-500">
      Already have an account?
      <NuxtLink to="/login" class="text-white hover:underline">
        Sign in now
      </NuxtLink>
    </div>
  </form>
</template>
