package com.nexa.catalog.repository;

import com.nexa.catalog.constants.DynamoKeys;
import com.nexa.catalog.model.TitleItem;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.*;
import software.amazon.awssdk.enhanced.dynamodb.model.*;

@Repository
public class TitleRepository {

  private final DynamoDbTable<TitleItem> table;

  public TitleRepository(
      DynamoDbEnhancedClient enhancedClient,
      @Value("${nexa.catalog.table-name}") String tableName) {
    this.table = enhancedClient.table(tableName, TableSchema.fromImmutableClass(TitleItem.class));
  }

  public TitleItem getItem(String pk, String sk) {
    return table.getItem(Key.builder().partitionValue(pk).sortValue(sk).build());
  }

  public List<TitleItem> getSeasonsForShow(Long tvId) {
    QueryEnhancedRequest request =
        QueryEnhancedRequest.builder()
            .queryConditional(
                QueryConditional.sortBeginsWith(
                    Key.builder()
                        .partitionValue(DynamoKeys.tvTitle(tvId))
                        .sortValue(DynamoKeys.SK_SEASON_PREFIX)
                        .build()))
            .build();

    return table.query(request).items().stream().toList();
  }
}
