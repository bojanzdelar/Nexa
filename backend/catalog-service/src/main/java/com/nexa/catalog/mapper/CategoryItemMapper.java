package com.nexa.catalog.mapper;

import com.nexa.catalog.api.CategoryItemResponse;
import com.nexa.catalog.model.CategoryItem;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CategoryItemMapper {

  @Mapping(target = "name", source = "title")
  CategoryItemResponse toResponse(CategoryItem item);
}
