package com.nexa.user.controller;

import com.nexa.user.api.ContinueWatchingResponse;
import com.nexa.user.api.EpisodeProgressRequest;
import com.nexa.user.api.MovieProgressRequest;
import com.nexa.user.api.ProgressResponse;
import com.nexa.user.service.PlaybackService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/me/playback")
@RequiredArgsConstructor
public class PlaybackController {

  private final PlaybackService playbackService;

  @GetMapping("/continue-watching")
  public List<ContinueWatchingResponse> getContinueWatching(
      @AuthenticationPrincipal Jwt jwt, @RequestParam(defaultValue = "20") int limit) {
    return playbackService.getContinueWatching(userId(jwt), limit);
  }

  @GetMapping("/tv/{tvId}/season/{season}/episode/{episode}")
  public ProgressResponse getEpisodeProgress(
      @AuthenticationPrincipal Jwt jwt,
      @PathVariable Long tvId,
      @PathVariable int season,
      @PathVariable int episode) {
    return playbackService.getEpisodeProgress(userId(jwt), tvId, season, episode);
  }

  @GetMapping("/movie/{movieId}")
  public ProgressResponse getMovieProgress(
      @AuthenticationPrincipal Jwt jwt, @PathVariable Long movieId) {
    return playbackService.getMovieProgress(userId(jwt), movieId);
  }

  @PostMapping("/episode/progress")
  public void updateEpisodeProgress(
      @AuthenticationPrincipal Jwt jwt, @RequestBody EpisodeProgressRequest request) {
    playbackService.updateEpisodeProgress(userId(jwt), request);
  }

  @PostMapping("/movie/progress")
  public void updateMovieProgress(
      @AuthenticationPrincipal Jwt jwt, @RequestBody MovieProgressRequest request) {
    playbackService.updateMovieProgress(userId(jwt), request);
  }

  @DeleteMapping("/tv/{tvId}")
  public void clearTvProgress(@AuthenticationPrincipal Jwt jwt, @PathVariable Long tvId) {
    playbackService.clearTvProgress(userId(jwt), tvId);
  }

  @DeleteMapping("/tv/{tvId}/season/{season}/episode/{episode}")
  public void clearEpisodeProgress(
      @AuthenticationPrincipal Jwt jwt,
      @PathVariable Long tvId,
      @PathVariable int season,
      @PathVariable int episode) {
    playbackService.clearEpisodeProgress(userId(jwt), tvId, season, episode);
  }

  @DeleteMapping("/movie/{movieId}")
  public void clearMovieProgress(@AuthenticationPrincipal Jwt jwt, @PathVariable Long movieId) {
    playbackService.clearMovieProgress(userId(jwt), movieId);
  }

  private String userId(Jwt jwt) {
    return jwt.getClaimAsString("sub");
  }
}
