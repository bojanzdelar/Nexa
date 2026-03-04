package com.nexa.user.api;

import java.time.Instant;

public record ContinueWatchingResponse(
    Long id, String type, Integer season, Integer episode, Instant updatedAt) {}
