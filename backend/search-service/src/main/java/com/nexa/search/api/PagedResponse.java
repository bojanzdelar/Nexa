package com.nexa.search.api;

import java.util.List;

public record PagedResponse(List<SearchResultResponse> results, int page, int size, long total) {}
