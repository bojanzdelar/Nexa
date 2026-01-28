package com.nexa.catalog.dto;

import java.util.List;

public record TvShowDto(
    Long id,
    String type,
    String name,
    String originalName,
    String tagline,
    String status,
    List<String> originCountry,
    String originalLanguage,
    String firstAirDate,
    List<GenreDto> genres,
    Integer numberOfSeasons,
    String overview,
    String posterPath,
    String backdropPath,
    List<CastMemberDto> cast,
    List<TitleSummaryDto> recommendations,
    List<SeasonDto> seasons) {}
