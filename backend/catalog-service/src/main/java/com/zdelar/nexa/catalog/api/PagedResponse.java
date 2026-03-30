package com.zdelar.nexa.catalog.api;

import java.util.List;

public record PagedResponse<T>(List<T> results, String nextCursor) {}
