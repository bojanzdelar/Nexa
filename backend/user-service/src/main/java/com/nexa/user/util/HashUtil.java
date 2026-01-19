package com.nexa.user.util;

import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public final class HashUtil {

  private HashUtil() {}

  public static String hmacSha256Hex(String input, String secret) {
    try {
      Mac mac = Mac.getInstance("HmacSHA256");
      mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
      byte[] digest = mac.doFinal(input.getBytes(StandardCharsets.UTF_8));
      return HexFormat.of().formatHex(digest);

    } catch (NoSuchAlgorithmException e) {
      throw new IllegalStateException("HmacSHA256 not available", e);
    } catch (InvalidKeyException e) {
      throw new IllegalStateException("Invalid HMAC key", e);
    }
  }
}
