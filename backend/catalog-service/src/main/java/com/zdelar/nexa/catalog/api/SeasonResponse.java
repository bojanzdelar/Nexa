package com.zdelar.nexa.catalog.api;

import java.util.List;

public record SeasonResponse(
    Integer seasonNumber, String airDate, List<EpisodeResponse> episodes) {}
