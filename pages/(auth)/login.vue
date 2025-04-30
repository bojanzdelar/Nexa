<script setup lang="ts">
import { useAuthStore } from "~/store";

definePageMeta({
  layout: "auth",
});

const router = useRouter();

const { logIn } = useAuthStore();

const form = ref({
  email: "",
  password: "",
});

const errors = ref({
  email: false,
  password: false,
});

const signIn = async () => {
  errors.value.email = !form.value.email;
  errors.value.password =
    !form.value.password ||
    form.value.password.length < 4 ||
    form.value.password.length > 60;

  if (errors.value.email || errors.value.password) return;

  await logIn({ email: form.value.email, password: form.value.password });

  router.push("/");
};
</script>

<template>
  <form
    class="z-10 w-full mt-24 space-y-8 rounded bg-black/75 py-10 px-6 md:mt-0 md:max-w-md md:px-14"
    @submit.prevent="signIn"
  >
    <h1 class="text-4xl font-semibold">Sign In</h1>

    <div class="space-y-4">
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
    </div>

    <button
      type="submit"
      class="w-full rounded bg-malachite py-3 font-semibold"
    >
      Sign In
    </button>

    <div class="text-neutral-500">
      New to Nexa?
      <NuxtLink to="/register" class="text-white hover:underline">
        Sign up now
      </NuxtLink>
    </div>
  </form>
</template>
