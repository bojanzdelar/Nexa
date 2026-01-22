package com.nexa.catalog.service;

import com.nexa.catalog.dto.CategoryItemDto;
import com.nexa.catalog.dto.PagedResponse;
import com.nexa.catalog.exception.NotFoundException;
import com.nexa.catalog.mapper.CategoryItemMapper;
import com.nexa.catalog.model.CategoryItem;
import com.nexa.catalog.repository.CategoryRepository;
import com.nexa.catalog.util.CursorUtil;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.enhanced.dynamodb.model.Page;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;

@Service
@RequiredArgsConstructor
public class CategoryService {

  private final CategoryRepository repository;
  private final CategoryItemMapper mapper;

  public PagedResponse<CategoryItemDto> getCategory(String pk, int limit, String cursor) {
    Map<String, AttributeValue> startKey = CursorUtil.decodeCursor(cursor);

    Page<CategoryItem> page = repository.queryCategory(pk, limit, startKey);

    if ((cursor == null || cursor.isBlank()) && page.items().isEmpty()) {
      throw new NotFoundException("Category not found");
    }

    List<CategoryItemDto> items = page.items().stream().map(mapper::toDto).toList();

    String nextCursor = CursorUtil.encodeCursor(page.lastEvaluatedKey());

    return new PagedResponse<>(items, nextCursor);
  }
}
