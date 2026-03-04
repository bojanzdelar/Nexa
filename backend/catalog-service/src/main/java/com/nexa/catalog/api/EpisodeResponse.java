package com.nexa.catalog.api;

public record EpisodeResponse(
    Integer episodeNumber,
    String name,
    String airDate,
    String overview,
    String stillPath,
    Integer runtime) {}
