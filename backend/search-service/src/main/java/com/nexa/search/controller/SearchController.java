package com.nexa.search.controller;

import com.nexa.search.dto.PagedResponse;
import com.nexa.search.service.SearchService;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/search")
@RequiredArgsConstructor
public class SearchController {

  private final SearchService service;

  @GetMapping
  public PagedResponse search(
      @RequestParam String q,
      @RequestParam(defaultValue = "1") int page,
      @RequestParam(defaultValue = "20") int size)
      throws IOException {
    return service.search(q, page, size);
  }
}
