package com.zdelar.nexa.user.controller;

import com.zdelar.nexa.user.api.ContinueWatchingResponse;
import com.zdelar.nexa.user.api.EpisodeProgressRequest;
import com.zdelar.nexa.user.api.MovieProgressRequest;
import com.zdelar.nexa.user.api.ProgressResponse;
import com.zdelar.nexa.user.service.ViewingService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/me/viewing")
@RequiredArgsConstructor
public class ViewingController {

  private final ViewingService viewingService;

  @GetMapping("/continue-watching")
  public List<ContinueWatchingResponse> getContinueWatching(
      @AuthenticationPrincipal Jwt jwt, @RequestParam(defaultValue = "20") int limit) {
    return viewingService.getContinueWatching(userId(jwt), limit);
  }

  @GetMapping("/tv/{tvId}/season/{season}/episode/{episode}")
  public ProgressResponse getEpisodeProgress(
      @AuthenticationPrincipal Jwt jwt,
      @PathVariable Long tvId,
      @PathVariable int season,
      @PathVariable int episode) {
    return viewingService.getEpisodeProgress(userId(jwt), tvId, season, episode);
  }

  @GetMapping("/movie/{movieId}")
  public ProgressResponse getMovieProgress(
      @AuthenticationPrincipal Jwt jwt, @PathVariable Long movieId) {
    return viewingService.getMovieProgress(userId(jwt), movieId);
  }

  @PostMapping("/episode/progress")
  public void updateEpisodeProgress(
      @AuthenticationPrincipal Jwt jwt, @RequestBody EpisodeProgressRequest request) {
    viewingService.updateEpisodeProgress(userId(jwt), request);
  }

  @PostMapping("/movie/progress")
  public void updateMovieProgress(
      @AuthenticationPrincipal Jwt jwt, @RequestBody MovieProgressRequest request) {
    viewingService.updateMovieProgress(userId(jwt), request);
  }

  @DeleteMapping("/tv/{tvId}")
  public void clearTvProgress(@AuthenticationPrincipal Jwt jwt, @PathVariable Long tvId) {
    viewingService.clearTvProgress(userId(jwt), tvId);
  }

  @DeleteMapping("/tv/{tvId}/season/{season}/episode/{episode}")
  public void clearEpisodeProgress(
      @AuthenticationPrincipal Jwt jwt,
      @PathVariable Long tvId,
      @PathVariable int season,
      @PathVariable int episode) {
    viewingService.clearEpisodeProgress(userId(jwt), tvId, season, episode);
  }

  @DeleteMapping("/movie/{movieId}")
  public void clearMovieProgress(@AuthenticationPrincipal Jwt jwt, @PathVariable Long movieId) {
    viewingService.clearMovieProgress(userId(jwt), movieId);
  }

  private String userId(Jwt jwt) {
    return jwt.getClaimAsString("sub");
  }
}
