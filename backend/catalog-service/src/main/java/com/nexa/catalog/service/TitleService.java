package com.nexa.catalog.service;

import static com.nexa.catalog.constants.DynamoKeys.*;

import com.nexa.catalog.dto.*;
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

  public MovieDto getMovieById(Long id) {
    String pk = movieTitle(id);

    TitleItem meta = repository.getItem(pk, SK_META);
    if (meta == null) throw new NotFoundException("Movie not found");

    TitleItem credits = repository.getItem(pk, SK_CREDITS);
    TitleItem recommendations = repository.getItem(pk, SK_RECOMMENDATIONS);

    return mapper.toMovieDto(meta, credits.getCast(), recommendations.getResults());
  }

  public TvShowDto getTvShowById(Long id) {
    String pk = tvTitle(id);

    TitleItem meta = repository.getItem(pk, SK_META);
    if (meta == null) throw new NotFoundException("TV show not found");

    TitleItem credits = repository.getItem(pk, SK_CREDITS);
    TitleItem recommendations = repository.getItem(pk, SK_RECOMMENDATIONS);
    List<TitleItem> seasonsRaw = repository.getSeasonsForShow(id);

    return mapper.toTvShowDto(meta, credits.getCast(), recommendations.getResults(), seasonsRaw);
  }

  public List<TitleSummaryDto> getBatchTitles(List<BatchTitleRequest> req) {
    return repository.getBatchTitles(req).stream().map(mapper::toTitleDto).toList();
  }
}
