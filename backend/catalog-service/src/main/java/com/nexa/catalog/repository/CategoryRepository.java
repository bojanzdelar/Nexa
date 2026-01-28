package com.nexa.catalog.repository;

import com.nexa.catalog.model.CategoryItem;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.*;
import software.amazon.awssdk.enhanced.dynamodb.model.*;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;

@Repository
public class CategoryRepository {

  private final DynamoDbTable<CategoryItem> table;

  public CategoryRepository(
      DynamoDbEnhancedClient enhancedClient,
      @Value("${aws.dynamodb.catalog.table-name}") String tableName) {
    this.table =
        enhancedClient.table(tableName, TableSchema.fromImmutableClass(CategoryItem.class));
  }

  public Page<CategoryItem> queryCategory(
      String pk, int limit, Map<String, AttributeValue> exclusiveStartKey) {
    QueryEnhancedRequest.Builder builder =
        QueryEnhancedRequest.builder()
            .queryConditional(QueryConditional.keyEqualTo(Key.builder().partitionValue(pk).build()))
            .scanIndexForward(false) // DESC
            .limit(limit);

    if (exclusiveStartKey != null && !exclusiveStartKey.isEmpty()) {
      builder.exclusiveStartKey(exclusiveStartKey);
    }

    return table.query(builder.build()).stream()
        .findFirst()
        .orElse(Page.builder(CategoryItem.class).items(List.of()).build());
  }
}
