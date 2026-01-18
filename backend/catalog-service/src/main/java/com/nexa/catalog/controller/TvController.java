package com.nexa.catalog.controller;

import com.nexa.catalog.constants.DynamoKeys;
import com.nexa.catalog.dto.CategoryItemDto;
import com.nexa.catalog.dto.PagedResponse;
import com.nexa.catalog.dto.TvShowDto;
import com.nexa.catalog.service.CategoryService;
import com.nexa.catalog.service.TitleService;
import com.nexa.catalog.util.PaginationUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/tv")
public class TvController {

  private final TitleService titleService;
  private final CategoryService categoryService;

  public TvController(TitleService titleService, CategoryService categoryService) {
    this.titleService = titleService;
    this.categoryService = categoryService;
  }

  @GetMapping("/{id}")
  public ResponseEntity<TvShowDto> getTvShow(@PathVariable Long id) {
    TvShowDto tvShow = titleService.getTvShowById(id);
    return tvShow == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(tvShow);
  }

  @GetMapping("/trending")
  public PagedResponse<CategoryItemDto> trending(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(DynamoKeys.TV_TRENDING, limit, cursor);
  }

  @GetMapping("/top-rated")
  public PagedResponse<CategoryItemDto> topRated(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(DynamoKeys.TV_TOP_RATED, limit, cursor);
  }

  @GetMapping("/latest")
  public PagedResponse<CategoryItemDto> latest(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(DynamoKeys.TV_LATEST, limit, cursor);
  }

  @GetMapping("/genres/{genreId}")
  public PagedResponse<CategoryItemDto> byGenre(
      @PathVariable int genreId,
      @RequestParam(defaultValue = "20") int limit,
      @RequestParam(required = false) String cursor) {
    return category(DynamoKeys.tvGenre(genreId), limit, cursor);
  }

  private PagedResponse<CategoryItemDto> category(String pk, int limit, String cursor) {
    return categoryService.getCategory(pk, PaginationUtil.clampLimit(limit), cursor);
  }
}
