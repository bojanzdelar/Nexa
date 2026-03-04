package com.nexa.user.api;

public record MovieProgressRequest(Long movieId, long progressSeconds, long durationSeconds) {}
