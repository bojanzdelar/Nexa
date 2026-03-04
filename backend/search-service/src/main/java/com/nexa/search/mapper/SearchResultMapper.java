package com.nexa.search.mapper;

import com.nexa.search.api.SearchResultResponse;
import com.nexa.search.model.SearchDocument;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface SearchResultMapper {

  SearchResultResponse toResponse(SearchDocument doc);
}
