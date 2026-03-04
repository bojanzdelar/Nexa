package com.nexa.user.constants;

public final class DynamoKeys {

  public static final String USER_PK_PREFIX = "USER#";

  public static final String PLAYBACK_PREFIX = "PLAYBACK#";
  public static final String WATCHLIST_PREFIX = "WATCHLIST#";

  public static final String MOVIE = "movie";
  public static final String TV = "tv";

  private DynamoKeys() {}

  public static String userPk(String userId) {
    return USER_PK_PREFIX + userId;
  }

  public static String playbackTvSk(Long tvId) {
    return PLAYBACK_PREFIX + TV + "#" + tvId + "#";
  }

  public static String playbackEpisodeSk(Long tvId, int season, int episode) {
    return PLAYBACK_PREFIX + TV + "#" + tvId + "#s" + season + "#e" + episode;
  }

  public static String playbackMovieSk(Long movieId) {
    return PLAYBACK_PREFIX + MOVIE + "#" + movieId;
  }

  public static String watchlistSk(String type, Long titleId) {
    return WATCHLIST_PREFIX + type + "#" + titleId;
  }
}
