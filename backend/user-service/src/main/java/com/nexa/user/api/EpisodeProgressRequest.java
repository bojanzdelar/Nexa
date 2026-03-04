package com.nexa.user.api;

public record EpisodeProgressRequest(
    Long tvId, int season, int episode, long progressSeconds, long durationSeconds) {}
