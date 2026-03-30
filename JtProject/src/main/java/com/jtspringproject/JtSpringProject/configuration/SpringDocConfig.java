package com.jtspringproject.JtSpringProject.configuration;
 
import org.springdoc.core.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
 
@Configuration
public class SpringDocConfig {
 
    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
                .group("jtspringproject-public")
                .pathsToMatch("/**")
                .build();
    }
 
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("JtSpringProject API")
                        .version("1.0")
                        .description("Backend APIs for E-commerce Project"));
    }
}
