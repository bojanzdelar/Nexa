package com.zdelar.nexa.user.service;

import static com.zdelar.nexa.user.constants.DynamoKeys.*;

import com.zdelar.nexa.user.api.WatchlistEntryResponse;
import com.zdelar.nexa.user.mapper.UserMapper;
import com.zdelar.nexa.user.repository.UserRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WatchlistService {

  private final UserRepository repository;
  private final UserMapper mapper;

  public List<WatchlistEntryResponse> getWatchlist(String userId) {
    return repository.findAllByPkAndSkPrefix(userPk(userId), WATCHLIST_PREFIX).stream()
        .map(mapper::toWatchlistEntryResponse)
        .toList();
  }

  public void addToWatchlist(String userId, String type, Long titleId) {
    repository.put(mapper.toWatchlistItem(userId, type, titleId));
  }

  public void removeFromWatchlist(String userId, String type, Long titleId) {
    repository.delete(userPk(userId), watchlistSk(type, titleId));
  }
}
