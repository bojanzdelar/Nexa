package com.nexa.user.controller;

import com.nexa.user.dto.WatchlistEntryDto;
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
  public List<WatchlistEntryDto> list(@AuthenticationPrincipal Jwt jwt) {
    return service.list(userId(jwt));
  }

  @PutMapping("/{type}/{titleId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void add(
      @AuthenticationPrincipal Jwt jwt, @PathVariable String type, @PathVariable String titleId) {
    service.add(userId(jwt), type, titleId);
  }

  @DeleteMapping("/{type}/{titleId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void remove(
      @AuthenticationPrincipal Jwt jwt, @PathVariable String type, @PathVariable String titleId) {
    service.remove(userId(jwt), type, titleId);
  }

  private String userId(Jwt jwt) {
    return jwt.getClaimAsString("sub");
  }
}
