package com.nexa.catalog.dto;

import java.util.List;

public record MovieDto(
    Long id,
    String type,
    String name,
    String originalName,
    String tagline,
    String status,
    List<String> originCountry,
    String originalLanguage,
    String releaseDate,
    List<GenreDto> genres,
    Integer runtime,
    String overview,
    String posterPath,
    String backdropPath,
    List<CastMemberDto> cast,
    List<TitleSummaryDto> recommendations) {}
