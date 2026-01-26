package com.nexa.search.controller;

import com.nexa.search.service.ReindexService;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin/search")
public class AdminController {

  private final ReindexService reindexService;

  @PostMapping("/reindex")
  public void reindex() throws IOException {
    reindexService.reindex();
  }
}
