package com.zdelar.nexa.user.api;

public record EpisodeProgressRequest(
    Long tvId, int season, int episode, long progressSeconds, long durationSeconds) {}
