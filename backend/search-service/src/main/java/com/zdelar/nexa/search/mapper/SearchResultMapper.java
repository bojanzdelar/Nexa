package com.zdelar.nexa.search.mapper;

import com.zdelar.nexa.search.api.SearchResultResponse;
import com.zdelar.nexa.search.model.SearchDocument;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface SearchResultMapper {

  SearchResultResponse toResponse(SearchDocument doc);
}
