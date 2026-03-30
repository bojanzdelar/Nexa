package com.zdelar.nexa.catalog.service;

import static com.zdelar.nexa.catalog.constants.DynamoKeys.*;

import com.zdelar.nexa.catalog.api.*;
import com.zdelar.nexa.catalog.api.BatchTitleRequest;
import com.zdelar.nexa.catalog.api.MovieResponse;
import com.zdelar.nexa.catalog.api.TitleSummaryResponse;
import com.zdelar.nexa.catalog.api.TvShowResponse;
import com.zdelar.nexa.catalog.mapper.TitleItemMapper;
import com.zdelar.nexa.catalog.model.*;
import com.zdelar.nexa.catalog.model.TitleItem;
import com.zdelar.nexa.catalog.repository.TitleRepository;
import com.zdelar.nexa.exception.NotFoundException;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TitleService {

  private final TitleRepository repository;
  private final TitleItemMapper mapper;

  public MovieResponse getMovieById(Long id) {
    String pk = movieTitle(id);

    TitleItem meta = repository.findByPkAndSk(pk, SK_META);
    if (meta == null) throw new NotFoundException("Movie not found");

    TitleItem credits = repository.findByPkAndSk(pk, SK_CREDITS);
    TitleItem recommendations = repository.findByPkAndSk(pk, SK_RECOMMENDATIONS);

    return mapper.toMovieResponse(
        meta,
        credits != null ? credits.getCast() : Collections.emptyList(),
        recommendations != null ? recommendations.getResults() : Collections.emptyList());
  }

  public TvShowResponse getTvShowById(Long id) {
    String pk = tvTitle(id);

    TitleItem meta = repository.findByPkAndSk(pk, SK_META);
    if (meta == null) throw new NotFoundException("TV show not found");

    TitleItem credits = repository.findByPkAndSk(pk, SK_CREDITS);
    TitleItem recommendations = repository.findByPkAndSk(pk, SK_RECOMMENDATIONS);
    List<TitleItem> seasonsRaw = repository.findSeasonsByTvId(id);

    return mapper.toTvShowResponse(
        meta,
        credits != null ? credits.getCast() : Collections.emptyList(),
        recommendations != null ? recommendations.getResults() : Collections.emptyList(),
        seasonsRaw);
  }

  public List<TitleSummaryResponse> getBatchTitles(List<BatchTitleRequest> req) {
    return repository.findBatchByTitle(req).stream().map(mapper::toTitleResponse).toList();
  }
}
