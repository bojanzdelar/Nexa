package com.nexa.catalog.model;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.*;

@Value
@Builder
@DynamoDbImmutable(builder = TitleItem.TitleItemBuilder.class)
public class TitleItem {
  @Getter(onMethod_ = {@DynamoDbPartitionKey, @DynamoDbAttribute("PK")})
  String pk;

  @Getter(onMethod_ = {@DynamoDbSortKey, @DynamoDbAttribute("SK")})
  String sk;

  Long id;
  String type;
  String title;

  @Getter(onMethod_ = @DynamoDbAttribute("original_title"))
  String originalTitle;

  String tagline;
  String status;

  @Getter(onMethod_ = @DynamoDbAttribute("origin_country"))
  List<String> originCountry;

  @Getter(onMethod_ = @DynamoDbAttribute("original_language"))
  String originalLanguage;

  @Getter(onMethod_ = @DynamoDbAttribute("first_air_date"))
  String firstAirDate;

  @Getter(onMethod_ = @DynamoDbAttribute("air_date"))
  String airDate;

  @Getter(onMethod_ = @DynamoDbAttribute("release_date"))
  String releaseDate;

  @Getter(onMethod_ = @DynamoDbAttribute("number_of_seasons"))
  Integer numberOfSeasons;

  @Getter(onMethod_ = @DynamoDbAttribute("season_number"))
  Integer seasonNumber;

  Integer runtime;
  String overview;

  @Getter(onMethod_ = @DynamoDbAttribute("poster_path"))
  String posterPath;

  @Getter(onMethod_ = @DynamoDbAttribute("backdrop_path"))
  String backdropPath;

  Double popularity;

  @Getter(onMethod_ = @DynamoDbAttribute("vote_average"))
  Double voteAverage;

  List<Genre> genres;
  List<CastMember> cast;
  List<Recommendation> results;
  List<Episode> episodes;
}
