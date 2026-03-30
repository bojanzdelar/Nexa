package com.zdelar.nexa.catalog.controller;

import static com.zdelar.nexa.catalog.constants.DynamoKeys.*;

import com.zdelar.nexa.catalog.api.CategoryItemResponse;
import com.zdelar.nexa.catalog.api.PagedResponse;
import com.zdelar.nexa.catalog.api.TvShowResponse;
import com.zdelar.nexa.catalog.service.CategoryService;
import com.zdelar.nexa.catalog.service.TitleService;
import com.zdelar.nexa.catalog.util.PaginationUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/tv")
@RequiredArgsConstructor
public class TvController {

  private final TitleService titleService;
  private final CategoryService categoryService;

  @GetMapping("/{id}")
  public ResponseEntity<TvShowResponse> getTvShow(@PathVariable Long id) {
    return ResponseEntity.ok(titleService.getTvShowById(id));
  }

  @GetMapping("/trending")
  public PagedResponse<CategoryItemResponse> trending(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(TV_TRENDING, limit, cursor);
  }

  @GetMapping("/top-rated")
  public PagedResponse<CategoryItemResponse> topRated(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(TV_TOP_RATED, limit, cursor);
  }

  @GetMapping("/latest")
  public PagedResponse<CategoryItemResponse> latest(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(TV_LATEST, limit, cursor);
  }

  @GetMapping("/genres/{genreId}")
  public PagedResponse<CategoryItemResponse> byGenre(
      @PathVariable int genreId,
      @RequestParam(defaultValue = "20") int limit,
      @RequestParam(required = false) String cursor) {
    return category(tvGenre(genreId), limit, cursor);
  }

  private PagedResponse<CategoryItemResponse> category(String pk, int limit, String cursor) {
    return categoryService.getCategory(pk, PaginationUtil.clampLimit(limit), cursor);
  }
}
