package com.nexa.user.service;

import com.nexa.user.dto.WatchlistEntryDto;
import com.nexa.user.mapper.UserMapper;
import com.nexa.user.repository.UserRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WatchlistService {

  private final UserRepository repository;
  private final UserMapper mapper;

  public List<WatchlistEntryDto> list(String userId) {
    return repository.getWatchlist(userId).stream().map(mapper::toWatchlistEntryDto).toList();
  }

  public void add(String userId, String type, String titleId) {
    repository.addWatchlist(userId, type, titleId);
  }

  public void remove(String userId, String type, String titleId) {
    repository.removeWatchlist(userId, type, titleId);
  }
}
