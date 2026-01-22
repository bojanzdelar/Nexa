package com.nexa.catalog.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nexa.catalog.exception.BadRequestException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;

public class CursorUtil {

  private static final ObjectMapper MAPPER = new ObjectMapper();

  private CursorUtil() {}

  public static String encodeCursor(Map<String, AttributeValue> lastEvaluatedKey) {
    if (lastEvaluatedKey == null || lastEvaluatedKey.isEmpty()) return null;

    try {
      Map<String, String> simple = new HashMap<>();
      for (var entry : lastEvaluatedKey.entrySet()) {
        AttributeValue av = entry.getValue();
        if (av.s() != null) {
          simple.put(entry.getKey(), av.s());
        } else if (av.n() != null) {
          simple.put(entry.getKey(), av.n());
        }
      }

      String json = MAPPER.writeValueAsString(simple);
      return Base64.getUrlEncoder()
          .withoutPadding()
          .encodeToString(json.getBytes(StandardCharsets.UTF_8));
    } catch (Exception e) {
      throw new IllegalStateException("Failed to encode cursor", e);
    }
  }

  public static Map<String, AttributeValue> decodeCursor(String cursor) {
    if (cursor == null || cursor.isBlank()) return null;

    try {
      byte[] decoded = Base64.getUrlDecoder().decode(cursor);
      String json = new String(decoded, StandardCharsets.UTF_8);

      Map<String, String> simple = MAPPER.readValue(json, new TypeReference<>() {});
      Map<String, AttributeValue> key = new HashMap<>();

      if (simple.containsKey("PK")) {
        key.put("PK", AttributeValue.builder().s(simple.get("PK")).build());
      }
      if (simple.containsKey("SK")) {
        key.put("SK", AttributeValue.builder().s(simple.get("SK")).build());
      }

      return key.isEmpty() ? null : key;
    } catch (Exception e) {
      throw new BadRequestException("Invalid cursor");
    }
  }
}
