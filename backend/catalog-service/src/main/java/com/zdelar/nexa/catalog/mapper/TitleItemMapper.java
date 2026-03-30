package com.zdelar.nexa.catalog.mapper;

import com.zdelar.nexa.catalog.api.*;
import com.zdelar.nexa.catalog.model.*;
import java.util.List;
import org.mapstruct.InheritConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueMappingStrategy;

@Mapper(
    componentModel = "spring",
    nullValueMappingStrategy = NullValueMappingStrategy.RETURN_DEFAULT)
public interface TitleItemMapper {

  @Mapping(target = "name", source = "meta.title")
  @Mapping(target = "originalName", source = "meta.originalTitle")
  @Mapping(target = "cast", source = "cast")
  @Mapping(target = "recommendations", source = "recommendations")
  MovieResponse toMovieResponse(
      TitleItem meta, List<CastMember> cast, List<Recommendation> recommendations);

  @Mapping(target = "name", source = "meta.title")
  @Mapping(target = "originalName", source = "meta.originalTitle")
  @Mapping(target = "cast", source = "cast")
  @Mapping(target = "recommendations", source = "recommendations")
  @Mapping(target = "seasons", source = "seasonsRaw")
  TvShowResponse toTvShowResponse(
      TitleItem meta,
      List<CastMember> cast,
      List<Recommendation> recommendations,
      List<TitleItem> seasonsRaw);

  @Mapping(target = "name", source = "title")
  TitleSummaryResponse toTitleResponse(TitleItem title);

  GenreResponse toGenreResponse(Genre g);

  CastMemberResponse toCastMemberResponse(CastMember c);

  @InheritConfiguration(name = "toTitleResponse")
  TitleSummaryResponse recommendationToTitleResponse(Recommendation r);

  SeasonResponse toSeasonResponse(TitleItem seasonItem);

  @Mapping(target = "name", source = "title")
  EpisodeResponse toEpisodeResponse(Episode e);
}
