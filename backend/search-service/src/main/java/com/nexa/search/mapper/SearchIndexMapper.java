package com.nexa.search.mapper;

import com.nexa.search.model.SearchDocument;
import java.util.Map;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;

@Component
public class SearchIndexMapper {

  public SearchDocument itemToDocument(Map<String, AttributeValue> item) {
    return SearchDocument.builder()
        .id(Long.parseLong(item.get("id").n()))
        .type(getS(item, "type"))
        .name(getS(item, "title"))
        .description(getS(item, "description"))
        .posterPath(getS(item, "poster_path"))
        .build();
  }

  private String getS(Map<String, AttributeValue> item, String key) {
    return item.containsKey(key) ? item.get(key).s() : "";
  }
}
