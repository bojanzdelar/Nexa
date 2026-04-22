package com.zdelar.nexa.catalog.controller;

import com.zdelar.nexa.catalog.api.BatchTitleRequest;
import com.zdelar.nexa.catalog.api.TitleSummaryResponse;
import com.zdelar.nexa.catalog.service.TitleService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/titles")
@RequiredArgsConstructor
public class TitleController {

  private final TitleService service;

  @PostMapping("/batch")
  public List<TitleSummaryResponse> getBatch(@RequestBody List<BatchTitleRequest> request) {
    return service.getBatchTitles(request);
  }
}
