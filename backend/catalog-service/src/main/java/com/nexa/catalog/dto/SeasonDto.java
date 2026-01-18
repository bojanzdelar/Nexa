package com.nexa.catalog.dto;

import java.util.List;

public record SeasonDto(Integer seasonNumber, String airDate, List<EpisodeDto> episodes) {}
