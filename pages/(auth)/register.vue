<script setup lang="ts">
import { useAuthStore } from "~/store";

definePageMeta({
  layout: "auth",
});

const { register } = useAuthStore();

const form = ref({
  email: "",
  password: "",
  confirmPassword: "",
  name: "",
});

const errors = ref({
  email: false,
  password: false,
  confirmPassword: false,
  name: false,
});

const signUp = async () => {
  errors.value.email = !form.value.email;

  errors.value.password =
    !form.value.password ||
    form.value.password.length < 4 ||
    form.value.password.length > 60;

  errors.value.confirmPassword =
    !form.value.confirmPassword ||
    form.value.password !== form.value.confirmPassword;

  errors.value.name = !form.value.name;

  if (
    errors.value.email ||
    errors.value.password ||
    errors.value.confirmPassword ||
    errors.value.name
  )
    return;

  await register({
    email: form.value.email,
    password: form.value.password,
    name: form.value.name,
  });
};
</script>

<template>
  <form
    class="z-10 w-full mt-24 space-y-8 rounded bg-black/75 py-10 px-6 md:mt-0 md:max-w-md md:px-14"
    @submit.prevent="signUp"
  >
    <h1 class="text-4xl font-semibold">Sign Up</h1>
    <div class="space-y-4">
      <label class="inline-block w-full">
        <input
          v-model="form.name"
          type="text"
          placeholder="Name"
          class="w-full rounded bg-neutral-800 px-5 py-3 placeholder-neutral-500 outline-none focus:bg-neutral-700"
        />

        <p v-if="errors.name" class="p-1 text-sm font-light text-malachite">
          Please enter your name.
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
          Your password must contain between 4 and 60 characters.
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
      class="w-full rounded bg-malachite py-3 font-semibold"
    >
      Sign Up
    </button>

    <div class="text-neutral-500">
      Already have an account?
      <NuxtLink to="/login" class="text-white hover:underline">
        Sign in now
      </NuxtLink>
    </div>
  </form>
</template>
