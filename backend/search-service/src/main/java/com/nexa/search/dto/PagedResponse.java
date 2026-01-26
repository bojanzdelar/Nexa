package com.nexa.search.dto;

import java.util.List;

public record PagedResponse(List<SearchResultDto> results, int page, int size, long total) {}
