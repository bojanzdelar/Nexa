package com.nexa.catalog.api;

public record CategoryItemResponse(
    Long id, String type, String name, String posterPath, String backdropPath, String tagline) {}
