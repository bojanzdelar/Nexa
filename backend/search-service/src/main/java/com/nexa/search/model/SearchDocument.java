package com.nexa.search.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchDocument {
  private Long id;
  private String type;
  private String name;
  private String description;
  private String posterPath;
}
