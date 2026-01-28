package com.nexa.search.service;

import static com.nexa.search.constants.DynamoKeys.*;
import static com.nexa.search.constants.SearchConstants.*;

import com.nexa.search.mapper.SearchIndexMapper;
import com.nexa.search.model.SearchDocument;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.BulkRequest;
import org.opensearch.client.opensearch.core.bulk.BulkOperation;
import org.opensearch.client.opensearch.core.bulk.IndexOperation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.QueryResponse;

@Service
@RequiredArgsConstructor
public class ReindexService {

  private final OpenSearchClient client;
  private final DynamoDbClient dynamo;
  private final SearchIndexMapper mapper;

  @Value("${aws.dynamodb.catalog.table-name}")
  private String catalogTableName;

  @Value("${aws.dynamodb.catalog.sk-index}")
  private String catalogTableSkIndex;

  public void reindex() throws IOException {
    Map<String, AttributeValue> lastKey = null;

    do {
      var response = queryBatch(lastKey);
      indexBatch(response.items());
      lastKey = response.lastEvaluatedKey();
    } while (lastKey != null && !lastKey.isEmpty());
  }

  private QueryResponse queryBatch(Map<String, AttributeValue> startKey) {
    return dynamo.query(
        r ->
            r.tableName(catalogTableName)
                .indexName(catalogTableSkIndex)
                .keyConditionExpression("SK = :meta")
                .expressionAttributeValues(Map.of(":meta", AttributeValue.fromS(SK_META)))
                .exclusiveStartKey(startKey));
  }

  private void indexBatch(List<Map<String, AttributeValue>> items) throws IOException {
    BulkRequest.Builder bulk = new BulkRequest.Builder();
    items.stream().map(this::buildIndexOperation).forEach(bulk::operations);
    client.bulk(bulk.build());
  }

  private BulkOperation buildIndexOperation(Map<String, AttributeValue> item) {
    var indexOperation =
        new IndexOperation.Builder<SearchDocument>()
            .index(INDEX_TITLES)
            .id(item.get("id").n())
            .document(mapper.itemToDocument(item))
            .build();

    return new BulkOperation.Builder().index(indexOperation).build();
  }
}
