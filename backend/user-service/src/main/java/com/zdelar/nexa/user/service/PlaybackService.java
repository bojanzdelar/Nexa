package com.zdelar.nexa.user.service;

import static com.zdelar.nexa.user.constants.DynamoKeys.*;

import com.zdelar.nexa.user.api.ContinueWatchingResponse;
import com.zdelar.nexa.user.api.EpisodeProgressRequest;
import com.zdelar.nexa.user.api.MovieProgressRequest;
import com.zdelar.nexa.user.api.ProgressResponse;
import com.zdelar.nexa.user.mapper.UserMapper;
import com.zdelar.nexa.user.model.UserItem;
import com.zdelar.nexa.user.repository.UserRepository;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;

@Service
public class PlaybackService {

  private final UserRepository userRepository;
  private final UserMapper userMapper;

  public PlaybackService(UserRepository userRepository, UserMapper userMapper) {
    this.userRepository = userRepository;
    this.userMapper = userMapper;
  }

  public List<ContinueWatchingResponse> getContinueWatching(String userId, int limit) {
    return userRepository.findAllByPkAndSkPrefix(userPk(userId), PLAYBACK_PREFIX).stream()
        .sorted(Comparator.comparing(UserItem::getUpdatedAt).reversed())
        .collect(
            Collectors.toMap(
                this::continueWatchingKey, // dedup key
                item -> item,
                (first, ignored) -> first, // keep newest
                LinkedHashMap::new))
        .values()
        .stream()
        .limit(limit)
        .map(userMapper::toContinueWatchingResponse)
        .toList();
  }

  private String continueWatchingKey(UserItem item) {
    String sk = item.getSk();

    if (sk.contains("#tv#")) {
      return sk.split("#s")[0];
    }

    return sk.replace("PLAYBACK#", "");
  }

  public ProgressResponse getEpisodeProgress(String userId, Long tvId, int season, int episode) {
    return userRepository
        .findByKey(userPk(userId), playbackEpisodeSk(tvId, season, episode))
        .map(userMapper::toProgressResponse)
        .orElse(new ProgressResponse(0));
  }

  public ProgressResponse getMovieProgress(String userId, Long movieId) {
    return userRepository
        .findByKey(userPk(userId), playbackMovieSk(movieId))
        .map(userMapper::toProgressResponse)
        .orElse(new ProgressResponse(0));
  }

  public void updateEpisodeProgress(String userId, EpisodeProgressRequest request) {
    boolean completed = isCompleted(request.progressSeconds(), request.durationSeconds());
    if (completed) {
      userRepository.delete(
          userPk(userId), playbackEpisodeSk(request.tvId(), request.season(), request.episode()));
      return;
    }

    userRepository.put(userMapper.toEpisodePlaybackItem(userId, request));
  }

  public void updateMovieProgress(String userId, MovieProgressRequest request) {
    boolean completed = isCompleted(request.progressSeconds(), request.durationSeconds());
    if (completed) {
      userRepository.delete(userPk(userId), playbackMovieSk(request.movieId()));
      return;
    }

    userRepository.put(userMapper.toMoviePlaybackItem(userId, request));
  }

  public void clearTvProgress(String userId, Long tvId) {
    userRepository
        .findAllByPkAndSkPrefix(userPk(userId), playbackTvSk(tvId))
        .forEach(item -> userRepository.delete(item.getPk(), item.getSk()));
  }

  public void clearEpisodeProgress(String userId, Long tvId, int season, int episode) {
    userRepository.delete(userPk(userId), playbackEpisodeSk(tvId, season, episode));
  }

  public void clearMovieProgress(String userId, Long movieId) {
    userRepository.delete(userPk(userId), playbackMovieSk(movieId));
  }

  private boolean isCompleted(long progress, long duration) {
    return duration > 0 && (double) progress / duration >= 0.95;
  }
}
