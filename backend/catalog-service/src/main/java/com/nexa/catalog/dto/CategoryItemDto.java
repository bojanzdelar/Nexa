package com.nexa.catalog.dto;

public record CategoryItemDto(
    Long id, String type, String name, String posterPath, String backdropPath, String tagline) {}
