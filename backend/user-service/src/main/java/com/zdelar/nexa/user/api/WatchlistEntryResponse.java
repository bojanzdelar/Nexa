package com.zdelar.nexa.user.api;

import java.time.Instant;

public record WatchlistEntryResponse(Long id, String type, Instant updatedAt) {}
