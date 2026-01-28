package com.nexa.catalog.controller;

import com.nexa.catalog.dto.BatchTitleRequest;
import com.nexa.catalog.dto.TitleSummaryDto;
import com.nexa.catalog.service.TitleService;
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
  public List<TitleSummaryDto> getBatch(@RequestBody List<BatchTitleRequest> request) {
    return service.getBatchTitles(request);
  }
}
