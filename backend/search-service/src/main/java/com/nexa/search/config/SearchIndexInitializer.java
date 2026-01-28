package com.nexa.search.config;

import static com.nexa.search.constants.SearchConstants.*;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch._types.analysis.Analyzer;
import org.opensearch.client.opensearch._types.analysis.TokenFilter;
import org.opensearch.client.opensearch._types.mapping.TypeMapping;
import org.opensearch.client.opensearch.indices.CreateIndexRequest;
import org.opensearch.client.opensearch.indices.IndexSettings;
import org.opensearch.client.opensearch.indices.IndexSettingsAnalysis;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class SearchIndexInitializer {

  private final OpenSearchClient client;

  @PostConstruct
  public void init() throws IOException {
    if (indexExists()) return;
    client.indices().create(buildIndexRequest());
  }

  private boolean indexExists() throws IOException {
    return client.indices().exists(e -> e.index(INDEX_TITLES)).value();
  }

  private CreateIndexRequest buildIndexRequest() {
    return new CreateIndexRequest.Builder()
        .index(INDEX_TITLES)
        .settings(buildSettings())
        .mappings(buildMappings())
        .build();
  }

  private IndexSettings buildSettings() {
    TokenFilter autocompleteFilter =
        new TokenFilter.Builder()
            .definition(d -> d.edgeNgram(e -> e.minGram(2).maxGram(20)))
            .build();

    Analyzer autocompleteAnalyzer =
        new Analyzer.Builder()
            .custom(cu -> cu.tokenizer("standard").filter("lowercase", "autocomplete_filter"))
            .build();

    IndexSettingsAnalysis analysis =
        new IndexSettingsAnalysis.Builder()
            .filter("autocomplete_filter", autocompleteFilter)
            .analyzer("autocomplete", autocompleteAnalyzer)
            .build();

    return new IndexSettings.Builder().analysis(analysis).build();
  }

  private TypeMapping buildMappings() {
    return new TypeMapping.Builder()
        .properties("id", p -> p.long_(l -> l))
        .properties("type", p -> p.keyword(k -> k))
        .properties("posterPath", p -> p.keyword(k -> k))
        .properties("name", p -> p.text(t -> t.analyzer("autocomplete").searchAnalyzer("standard")))
        .properties("description", p -> p.text(t -> t))
        .build();
  }
}
