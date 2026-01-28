package com.nexa.catalog.controller;

import static com.nexa.catalog.constants.DynamoKeys.*;

import com.nexa.catalog.dto.CategoryItemDto;
import com.nexa.catalog.dto.MovieDto;
import com.nexa.catalog.dto.PagedResponse;
import com.nexa.catalog.service.CategoryService;
import com.nexa.catalog.service.TitleService;
import com.nexa.catalog.util.PaginationUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/movies")
@RequiredArgsConstructor
public class MovieController {

  private final TitleService titleService;
  private final CategoryService categoryService;

  @GetMapping("/{id}")
  public ResponseEntity<MovieDto> getMovie(@PathVariable Long id) {
    return ResponseEntity.ok(titleService.getMovieById(id));
  }

  @GetMapping("/trending")
  public PagedResponse<CategoryItemDto> trending(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(MOVIE_TRENDING, limit, cursor);
  }

  @GetMapping("/top-rated")
  public PagedResponse<CategoryItemDto> topRated(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(MOVIE_TOP_RATED, limit, cursor);
  }

  @GetMapping("/latest")
  public PagedResponse<CategoryItemDto> latest(
      @RequestParam(defaultValue = "20") int limit, @RequestParam(required = false) String cursor) {
    return category(MOVIE_LATEST, limit, cursor);
  }

  @GetMapping("/genres/{genreId}")
  public PagedResponse<CategoryItemDto> byGenre(
      @PathVariable int genreId,
      @RequestParam(defaultValue = "20") int limit,
      @RequestParam(required = false) String cursor) {
    return category(movieGenre(genreId), limit, cursor);
  }

  private PagedResponse<CategoryItemDto> category(String pk, int limit, String cursor) {
    return categoryService.getCategory(pk, PaginationUtil.clampLimit(limit), cursor);
  }
}
