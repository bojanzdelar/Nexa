package com.nexa.user.constants;

public final class DynamoKeys {

  public static final String USER_PK_PREFIX = "USER#";

  public static final String WATCHLIST_PREFIX = "WATCHLIST#";
  public static final String PROGRESS_PREFIX = "PROGRESS#";
  public static final String HISTORY_PREFIX = "HISTORY#";

  public static final String MOVIE = "MOVIE";
  public static final String SHOW = "SHOW";
  public static final String EPISODE = "EPISODE";

  private DynamoKeys() {}

  public static String userPk(String userId) {
    return USER_PK_PREFIX + userId;
  }

  public static String watchlistSk(String type, String titleId) {
    return WATCHLIST_PREFIX + type + "#" + titleId;
  }
}
