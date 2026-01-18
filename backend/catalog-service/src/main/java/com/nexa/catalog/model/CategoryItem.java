package com.nexa.catalog.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.*;

@Value
@Builder
@DynamoDbImmutable(builder = CategoryItem.CategoryItemBuilder.class)
public class CategoryItem {
  @Getter(onMethod_ = {@DynamoDbPartitionKey, @DynamoDbAttribute("PK")})
  String pk;

  @Getter(onMethod_ = {@DynamoDbSortKey, @DynamoDbAttribute("SK")})
  String sk;

  Long id;
  String type;
  String title;

  @Getter(onMethod_ = @DynamoDbAttribute("poster_path"))
  String posterPath;

  @Getter(onMethod_ = @DynamoDbAttribute("backdrop_path"))
  String backdropPath;

  String tagline;
}
