package com.nexa.search.mapper;

import com.nexa.search.dto.SearchResultDto;
import com.nexa.search.model.SearchDocument;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface SearchResultMapper {

  SearchResultDto toDto(SearchDocument doc);
}
