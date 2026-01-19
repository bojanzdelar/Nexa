package com.nexa.catalog.util;

public class PaginationUtil {

  private PaginationUtil() {}

  public static int clampLimit(int limit) {
    if (limit < 1) return 1;
    return Math.min(limit, 50);
  }
}
