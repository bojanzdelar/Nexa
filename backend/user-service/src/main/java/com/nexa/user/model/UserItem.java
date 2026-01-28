package com.nexa.user.model;

import java.time.Instant;
import lombok.Builder;
import lombok.Getter;
import lombok.Value;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.*;

@Value
@Builder
@DynamoDbImmutable(builder = UserItem.UserItemBuilder.class)
public class UserItem {

  @Getter(onMethod_ = {@DynamoDbPartitionKey, @DynamoDbAttribute("PK")})
  String pk;

  @Getter(onMethod_ = {@DynamoDbSortKey, @DynamoDbAttribute("SK")})
  String sk;

  Instant updatedAt;
}
