package com.nexa.catalog.model;

import lombok.Builder;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbImmutable;

@Value
@Builder
@DynamoDbImmutable(builder = Genre.GenreBuilder.class)
public class Genre {
  Integer id;
  String name;
}
