package com.nexa.catalog.api;

import java.util.List;

public record MovieResponse(
    Long id,
    String type,
    String name,
    String originalName,
    String tagline,
    String status,
    List<String> originCountry,
    String originalLanguage,
    String releaseDate,
    List<GenreResponse> genres,
    Integer runtime,
    String overview,
    String posterPath,
    String backdropPath,
    List<CastMemberResponse> cast,
    List<TitleSummaryResponse> recommendations) {}
