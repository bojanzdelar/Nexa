package com.zdelar.nexa.catalog.service;

import com.zdelar.nexa.catalog.api.CategoryItemResponse;
import com.zdelar.nexa.catalog.api.PagedResponse;
import com.zdelar.nexa.catalog.mapper.CategoryItemMapper;
import com.zdelar.nexa.catalog.model.CategoryItem;
import com.zdelar.nexa.catalog.repository.CategoryRepository;
import com.zdelar.nexa.catalog.util.CursorUtil;
import com.zdelar.nexa.exception.NotFoundException;
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

  public PagedResponse<CategoryItemResponse> getCategory(String pk, int limit, String cursor) {
    Map<String, AttributeValue> startKey = CursorUtil.decodeCursor(cursor);

    Page<CategoryItem> page = repository.findCategoryPage(pk, limit, startKey);

    if ((cursor == null || cursor.isBlank()) && page.items().isEmpty()) {
      throw new NotFoundException("Category not found");
    }

    List<CategoryItemResponse> items = page.items().stream().map(mapper::toResponse).toList();

    String nextCursor = CursorUtil.encodeCursor(page.lastEvaluatedKey());

    return new PagedResponse<>(items, nextCursor);
  }
}
