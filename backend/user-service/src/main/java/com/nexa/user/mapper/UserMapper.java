package com.nexa.user.mapper;

import static com.nexa.user.constants.DynamoKeys.*;

import com.nexa.user.api.*;
import com.nexa.user.model.UserItem;
import java.time.Instant;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

  private static final long PLAYBACK_TTL_SECONDS = 60L * 60 * 24 * 90;

  public UserItem toPlaybackItem(
      String userId, String playbackSk, long progressSeconds, long durationSeconds) {
    return UserItem.builder()
        .pk(userPk(userId))
        .sk(playbackSk)
        .updatedAt(Instant.now())
        .progressSeconds(progressSeconds)
        .durationSeconds(durationSeconds)
        .expiresAt(Instant.now().plusSeconds(PLAYBACK_TTL_SECONDS).getEpochSecond())
        .build();
  }

  public UserItem toEpisodePlaybackItem(String userId, EpisodeProgressRequest request) {
    return toPlaybackItem(
        userId,
        playbackEpisodeSk(request.tvId(), request.season(), request.episode()),
        request.progressSeconds(),
        request.durationSeconds());
  }

  public UserItem toMoviePlaybackItem(String userId, MovieProgressRequest request) {
    return toPlaybackItem(
        userId,
        playbackMovieSk(request.movieId()),
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
