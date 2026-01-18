package com.nexa.catalog.dto;

import java.util.List;

public record PagedResponse<T>(List<T> results, String nextCursor) {}
