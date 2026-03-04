package com.nexa.user.controller;

import com.nexa.user.api.WatchlistEntryResponse;
import com.nexa.user.service.WatchlistService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/me/watchlist")
@RequiredArgsConstructor
public class WatchlistController {

  private final WatchlistService service;

  @GetMapping
  public List<WatchlistEntryResponse> getWatchlist(@AuthenticationPrincipal Jwt jwt) {
    return service.getWatchlist(userId(jwt));
  }

  @PutMapping("/{type}/{titleId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void addToWatchlist(
      @AuthenticationPrincipal Jwt jwt, @PathVariable String type, @PathVariable Long titleId) {
    service.addToWatchlist(userId(jwt), type, titleId);
  }

  @DeleteMapping("/{type}/{titleId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void removeFromWatchlist(
      @AuthenticationPrincipal Jwt jwt, @PathVariable String type, @PathVariable Long titleId) {
    service.removeFromWatchlist(userId(jwt), type, titleId);
  }

  private String userId(Jwt jwt) {
    return jwt.getClaimAsString("sub");
  }
}
