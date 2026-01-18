package com.nexa.catalog.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbAttribute;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbImmutable;

@Value
@Builder
@DynamoDbImmutable(builder = Episode.EpisodeBuilder.class)
public class Episode {
  @Getter(onMethod_ = @DynamoDbAttribute("episode_number"))
  Integer episodeNumber;

  String title;

  @Getter(onMethod_ = @DynamoDbAttribute("air_date"))
  String airDate;

  String overview;

  @Getter(onMethod_ = @DynamoDbAttribute("still_path"))
  String stillPath;

  Integer runtime;
}
