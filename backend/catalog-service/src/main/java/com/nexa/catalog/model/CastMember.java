package com.nexa.catalog.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbAttribute;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbImmutable;

@Value
@Builder
@DynamoDbImmutable(builder = CastMember.CastMemberBuilder.class)
public class CastMember {
  Long id;
  String name;
  String character;

  @Getter(onMethod_ = @DynamoDbAttribute("profile_path"))
  String profilePath;
}
