package com.zdelar.nexa.catalog.mapper;

import com.zdelar.nexa.catalog.api.CategoryItemResponse;
import com.zdelar.nexa.catalog.model.CategoryItem;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CategoryItemMapper {

  @Mapping(target = "name", source = "title")
  CategoryItemResponse toResponse(CategoryItem item);
}
