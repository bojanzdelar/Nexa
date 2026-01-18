package com.nexa.catalog.dto;

public record EpisodeDto(
    Integer episodeNumber,
    String name,
    String airDate,
    String overview,
    String stillPath,
    Integer runtime) {}
