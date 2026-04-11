package com.zdelar.nexa.user.constants;

public final class DynamoKeys {

  public static final String USER_PK_PREFIX = "USER#";

  public static final String VIEWING_PREFIX = "VIEWING#";
  public static final String WATCHLIST_PREFIX = "WATCHLIST#";

  public static final String MOVIE = "movie";
  public static final String TV = "tv";

  private DynamoKeys() {}

  public static String userPk(String userId) {
    return USER_PK_PREFIX + userId;
  }

  public static String viewingTvSk(Long tvId) {
    return VIEWING_PREFIX + TV + "#" + tvId + "#";
  }

  public static String viewingEpisodeSk(Long tvId, int season, int episode) {
    return VIEWING_PREFIX + TV + "#" + tvId + "#s" + season + "#e" + episode;
  }

  public static String viewingMovieSk(Long movieId) {
    return VIEWING_PREFIX + MOVIE + "#" + movieId;
  }

  public static String watchlistSk(String type, Long titleId) {
    return WATCHLIST_PREFIX + type + "#" + titleId;
  }
}
