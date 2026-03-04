package com.nexa.user;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.nexa")
public class UserServiceApplication {

  static void main(String[] args) {
    SpringApplication.run(UserServiceApplication.class, args);
  }
}
