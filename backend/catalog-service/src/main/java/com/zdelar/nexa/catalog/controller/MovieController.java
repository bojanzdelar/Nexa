package com.zdelar.nexa.catalog.controller;

import static com.zdelar.nexa.catalog.constants.DynamoKeys.*;

import com.zdelar.nexa.catalog.api.CategoryItemResponse;
import com.zdelar.nexa.catalog.api.MovieResponse;
import com.zdelar.nexa.catalog.api.PagedResponse;
import com.zdelar.nexa.catalog.service.CategoryService;
import com.zdelar.nexa.catalog.service.TitleService;
import com.zdelar.nexa.catalog.util.PaginationUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/movies")
@RequiredArgsConstructor
public class MovieController {

  private final TitleService titleService;
  private final CategoryService categoryService;

  @GetMapping("/{id}")
  public ResponseEntity<MovieResponse> getMovie(@PathVariable Long id) {
    return ResponseEntity.ok(titleService.getMovieById(id));
  }

  @GetMapping("/trending")
  public PagedResponse<CategoryItemResponse> trending(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(MOVIE_TRENDING, limit, cursor);
  }

  @GetMapping("/top-rated")
  public PagedResponse<CategoryItemResponse> topRated(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(MOVIE_TOP_RATED, limit, cursor);
  }

  @GetMapping("/latest")
  public PagedResponse<CategoryItemResponse> latest(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(MOVIE_LATEST, limit, cursor);
  }

  @GetMapping("/genres/{genreId}")
  public PagedResponse<CategoryItemResponse> byGenre(
      @PathVariable int genreId,
      @RequestParam(defaultValue = "20") int limit,
      @RequestParam(required = false) String cursor) {
    return category(movieGenre(genreId), limit, cursor);
  }

  private PagedResponse<CategoryItemResponse> category(String pk, int limit, String cursor) {
    return categoryService.getCategory(pk, PaginationUtil.clampLimit(limit), cursor);
  }
}
