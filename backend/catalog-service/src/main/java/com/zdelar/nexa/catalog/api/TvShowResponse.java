package com.zdelar.nexa.catalog.api;

import java.util.List;

public record TvShowResponse(
    Long id,
    String type,
    String name,
    String originalName,
    String tagline,
    String status,
    List<String> originCountry,
    String originalLanguage,
    String firstAirDate,
    List<GenreResponse> genres,
    Integer numberOfSeasons,
    String overview,
    String posterPath,
    String backdropPath,
    List<CastMemberResponse> cast,
    List<TitleSummaryResponse> recommendations,
    List<SeasonResponse> seasons) {}
