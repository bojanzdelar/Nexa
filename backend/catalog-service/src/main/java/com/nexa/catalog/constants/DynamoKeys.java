package com.nexa.catalog.constants;

public final class DynamoKeys {
  public static final String SK_META = "META";
  public static final String SK_CREDITS = "CREDITS";
  public static final String SK_RECOMMENDATIONS = "RECOMMENDATIONS";
  public static final String SK_SEASON_PREFIX = "SEASON#";

  public static final String TV_TRENDING = "CAT#tv#trending";
  public static final String TV_TOP_RATED = "CAT#tv#top-rated";
  public static final String TV_LATEST = "CAT#tv#latest";

  public static final String MOVIE_TRENDING = "CAT#movie#trending";
  public static final String MOVIE_TOP_RATED = "CAT#movie#top-rated";
  public static final String MOVIE_LATEST = "CAT#movie#latest";

  private DynamoKeys() {}

  public static String tvTitle(Long tvId) {
    return "TITLE#tv#" + tvId;
  }

  public static String movieTitle(Long movieId) {
    return "TITLE#movie#" + movieId;
  }

  public static String tvGenre(int genreId) {
    return "CAT#tv#genre#" + genreId;
  }

  public static String movieGenre(int genreId) {
    return "CAT#movie#genre#" + genreId;
  }
}
