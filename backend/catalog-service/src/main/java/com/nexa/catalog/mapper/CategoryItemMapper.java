package com.nexa.catalog.mapper;

import com.nexa.catalog.dto.CategoryItemDto;
import com.nexa.catalog.model.CategoryItem;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CategoryItemMapper {

  @Mapping(target = "name", source = "title")
  CategoryItemDto toDto(CategoryItem item);
}
