package com.nexa.catalog.service;

import static com.nexa.catalog.constants.DynamoKeys.*;

import com.nexa.catalog.api.*;
import com.nexa.catalog.exception.NotFoundException;
import com.nexa.catalog.mapper.TitleItemMapper;
import com.nexa.catalog.model.*;
import com.nexa.catalog.repository.TitleRepository;
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

    return mapper.toMovieResponse(meta, credits.getCast(), recommendations.getResults());
  }

  public TvShowResponse getTvShowById(Long id) {
    String pk = tvTitle(id);

    TitleItem meta = repository.findByPkAndSk(pk, SK_META);
    if (meta == null) throw new NotFoundException("TV show not found");

    TitleItem credits = repository.findByPkAndSk(pk, SK_CREDITS);
    TitleItem recommendations = repository.findByPkAndSk(pk, SK_RECOMMENDATIONS);
    List<TitleItem> seasonsRaw = repository.findSeasonsByTvId(id);

    return mapper.toTvShowResponse(
        meta, credits.getCast(), recommendations.getResults(), seasonsRaw);
  }

  public List<TitleSummaryResponse> getBatchTitles(List<BatchTitleRequest> req) {
    return repository.findBatchByTitle(req).stream().map(mapper::toTitleResponse).toList();
  }
}
