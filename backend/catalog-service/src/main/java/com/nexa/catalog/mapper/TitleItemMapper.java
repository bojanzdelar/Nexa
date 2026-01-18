package com.nexa.catalog.mapper;

import com.nexa.catalog.dto.*;
import com.nexa.catalog.model.*;
import java.util.List;
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
  MovieDto toMovieDto(TitleItem meta, List<CastMember> cast, List<Recommendation> recommendations);

  @Mapping(target = "name", source = "meta.title")
  @Mapping(target = "originalName", source = "meta.originalTitle")
  @Mapping(target = "cast", source = "cast")
  @Mapping(target = "recommendations", source = "recommendations")
  @Mapping(target = "seasons", source = "seasonsRaw")
  TvShowDto toTvShowDto(
      TitleItem meta,
      List<CastMember> cast,
      List<Recommendation> recommendations,
      List<TitleItem> seasonsRaw);

  GenreDto toGenreDto(Genre g);

  CastMemberDto toCastMemberDto(CastMember c);

  @Mapping(target = "name", source = "title")
  RecommendationDto toRecommendationDto(Recommendation r);

  SeasonDto toSeasonDto(TitleItem seasonItem);

  @Mapping(target = "name", source = "title")
  EpisodeDto toEpisodeDto(Episode e);
}
