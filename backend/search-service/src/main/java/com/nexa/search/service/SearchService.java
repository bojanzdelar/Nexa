package com.nexa.search.service;

import static com.nexa.search.constants.SearchConstants.*;

import com.nexa.search.dto.PagedResponse;
import com.nexa.search.dto.SearchResultDto;
import com.nexa.search.mapper.SearchResultMapper;
import com.nexa.search.model.SearchDocument;
import java.io.IOException;
import java.util.List;
import java.util.function.Function;
import lombok.RequiredArgsConstructor;
import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch._types.query_dsl.MultiMatchQuery;
import org.opensearch.client.opensearch._types.query_dsl.Query;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
import org.opensearch.client.util.ObjectBuilder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SearchService {

  private final OpenSearchClient client;
  private final SearchResultMapper mapper;

  public PagedResponse search(String query, int page, int size) throws IOException {

    SearchResponse<SearchDocument> response =
        client.search(buildSearchRequest(query, page, size), SearchDocument.class);

    List<SearchResultDto> results =
        response.hits().hits().stream().map(hit -> mapper.toDto(hit.source())).toList();

    return new PagedResponse(
        results,
        page,
        size,
        response.hits().total() != null ? response.hits().total().value() : results.size());
  }

  private Function<SearchRequest.Builder, ObjectBuilder<SearchRequest>> buildSearchRequest(
      String query, int page, int size) {
    var multiMatch =
        new MultiMatchQuery.Builder()
            .fields("name^3", "description")
            .query(query)
            .fuzziness("AUTO")
            .build();

    var searchQuery = new Query.Builder().multiMatch(multiMatch).build();

    return s ->
        s.index(INDEX_TITLES).from((page - 1) * size).size(size).query(searchQuery);
  }
}
