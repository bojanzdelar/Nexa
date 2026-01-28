package com.nexa.catalog.repository;

import static com.nexa.catalog.constants.DynamoKeys.*;

import com.nexa.catalog.dto.BatchTitleRequest;
import com.nexa.catalog.model.TitleItem;
import java.util.List;
import java.util.stream.StreamSupport;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.*;
import software.amazon.awssdk.enhanced.dynamodb.model.*;

@Repository
public class TitleRepository {

  private final DynamoDbEnhancedClient enhancedClient;
  private final DynamoDbTable<TitleItem> table;

  public TitleRepository(
      DynamoDbEnhancedClient enhancedClient,
      @Value("${aws.dynamodb.catalog.table-name}") String tableName) {
    this.enhancedClient = enhancedClient;
    this.table = enhancedClient.table(tableName, TableSchema.fromImmutableClass(TitleItem.class));
  }

  public TitleItem getItem(String pk, String sk) {
    return table.getItem(Key.builder().partitionValue(pk).sortValue(sk).build());
  }

  public List<TitleItem> getBatchTitles(List<BatchTitleRequest> req) {
    if (req.isEmpty()) return List.of();

    var batchBuilder = ReadBatch.builder(TitleItem.class).mappedTableResource(table);

    req.stream()
        .distinct()
        .map(
            r -> Key.builder().partitionValue(titlePk(r.type(), r.id())).sortValue(SK_META).build())
        .forEach(batchBuilder::addGetItem);

    var resultPages =
        enhancedClient.batchGetItem(
            BatchGetItemEnhancedRequest.builder().readBatches(batchBuilder.build()).build());

    return StreamSupport.stream(resultPages.resultsForTable(table).spliterator(), false).toList();
  }

  public List<TitleItem> getSeasonsForShow(Long tvId) {
    QueryEnhancedRequest request =
        QueryEnhancedRequest.builder()
            .queryConditional(
                QueryConditional.sortBeginsWith(
                    Key.builder()
                        .partitionValue(tvTitle(tvId))
                        .sortValue(SK_SEASON_PREFIX)
                        .build()))
            .build();

    return table.query(request).items().stream().toList();
  }
}
