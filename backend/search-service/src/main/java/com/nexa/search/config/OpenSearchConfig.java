package com.nexa.search.config;

import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.transport.OpenSearchTransport;
import org.opensearch.client.transport.aws.AwsSdk2Transport;
import org.opensearch.client.transport.aws.AwsSdk2TransportOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.http.SdkHttpClient;
import software.amazon.awssdk.http.apache.ApacheHttpClient;
import software.amazon.awssdk.regions.Region;

@Configuration
public class OpenSearchConfig {

  @Value("${aws.opensearch.endpoint}")
  private String endpoint;

  @Value("${aws.region}")
  private String region;

  @Bean
  public SdkHttpClient apacheHttpClient() {
    return ApacheHttpClient.builder().build();
  }

  @Bean
  public OpenSearchTransport openSearchTransport(SdkHttpClient httpClient) {
    return new AwsSdk2Transport(
        httpClient,
        endpoint,
        Region.of(region),
        AwsSdk2TransportOptions.builder()
            .setCredentials(DefaultCredentialsProvider.builder().build())
            .build());
  }

  @Bean
  public OpenSearchClient openSearchClient(OpenSearchTransport transport) {
    return new OpenSearchClient(transport);
  }
}
