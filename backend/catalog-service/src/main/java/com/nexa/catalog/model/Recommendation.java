package com.nexa.catalog.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbAttribute;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbImmutable;

@Value
@Builder
@DynamoDbImmutable(builder = Recommendation.RecommendationBuilder.class)
public class Recommendation {
  Long id;
  String type;
  String title;

  @Getter(onMethod_ = @DynamoDbAttribute("poster_path"))
  String posterPath;
}
