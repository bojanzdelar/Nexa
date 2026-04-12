package com.zdelar.nexa.user.mapper;

import static com.zdelar.nexa.user.constants.DynamoKeys.*;

import com.zdelar.nexa.user.api.*;
import com.zdelar.nexa.user.model.UserItem;
import java.time.Instant;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

  private static final long VIEWING_TTL_SECONDS = 60L * 60 * 24 * 90; // 90 days

  public UserItem toViewingItem(
      String userId, String viewingSk, long progressSeconds, long durationSeconds) {
    return UserItem.builder()
        .pk(userPk(userId))
        .sk(viewingSk)
        .updatedAt(Instant.now())
        .progressSeconds(progressSeconds)
        .durationSeconds(durationSeconds)
        .expiresAt(Instant.now().plusSeconds(VIEWING_TTL_SECONDS).getEpochSecond())
        .build();
  }

  public UserItem toEpisodeViewingItem(String userId, EpisodeProgressRequest request) {
    return toViewingItem(
        userId,
        viewingEpisodeSk(request.tvId(), request.season(), request.episode()),
        request.progressSeconds(),
        request.durationSeconds());
  }

  public UserItem toMovieViewingItem(String userId, MovieProgressRequest request) {
    return toViewingItem(
        userId,
        viewingMovieSk(request.movieId()),
        request.progressSeconds(),
        request.durationSeconds());
  }

  public UserItem toWatchlistItem(String userId, String type, Long titleId) {
    return UserItem.builder()
        .pk(userPk(userId))
        .sk(watchlistSk(type, titleId))
        .updatedAt(Instant.now())
        .build();
  }

  public ContinueWatchingResponse toContinueWatchingResponse(UserItem item) {
    String[] parts = item.getSk().split("#");

    if ("movie".equals(parts[1])) {
      return new ContinueWatchingResponse(
          Long.valueOf(parts[2]), parts[1], null, null, item.getUpdatedAt());
    }

    if ("tv".equals(parts[1])) {
      return new ContinueWatchingResponse(
          Long.valueOf(parts[2]),
          parts[1],
          Integer.valueOf(parts[3].substring(1)),
          Integer.valueOf(parts[4].substring(1)),
          item.getUpdatedAt());
    }

    throw new IllegalStateException("Unknown continue-watching SK: " + item.getSk());
  }

  public ProgressResponse toProgressResponse(UserItem item) {
    return new ProgressResponse(item.getProgressSeconds());
  }

  public WatchlistEntryResponse toWatchlistEntryResponse(UserItem item) {
    String[] parts = item.getSk().split("#");
    return new WatchlistEntryResponse(Long.valueOf(parts[2]), parts[1], item.getUpdatedAt());
  }
}
