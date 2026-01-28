package com.nexa.user.dto;

import java.time.Instant;

public record WatchlistEntryDto(Long id, String type, Instant updatedAt) {}
