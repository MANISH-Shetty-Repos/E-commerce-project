package com.jtspringproject.JtSpringProject.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import org.springframework.security.web.SecurityFilterChain;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.userService;

import lombok.extern.slf4j.Slf4j;

@Configuration
@EnableWebSecurity
@Slf4j
public class SecurityConfiguration {

    private final userService userService;

    public SecurityConfiguration(userService userService) {
        this.userService = userService;
    }

    // Chain 1: Admin Area
    @Bean
    @Order(1)
    public SecurityFilterChain adminFilterChain(HttpSecurity http) throws Exception {
        http
                .antMatcher("/admin/**")
                .authorizeRequests()
                .antMatchers("/admin/login").permitAll()
                .anyRequest().hasRole("ADMIN")
                .and()
                .formLogin()
                .loginPage("/admin/login")
                .loginProcessingUrl("/admin/loginvalidate")
                .defaultSuccessUrl("/admin/Dashboard", true)
                .failureUrl("/admin/login?error=true")
                .and()
                .logout()
                .logoutUrl("/admin/logout")
                .logoutSuccessUrl("/admin/login")
                .deleteCookies("JSESSIONID")
                .and()
                .csrf().disable();

        return http.build();
    }

    // Chain 2: User Area and everything else
    @Bean
    @Order(2)
    public SecurityFilterChain userFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                // Public paths
                .antMatchers("/login", "/register", "/newuserregister", "/test", "/test2").permitAll()
                .antMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                .antMatchers("/resources/**", "/static/**", "/css/**", "/js/**", "/images/**", "/favicon.ico")
                .permitAll()
                // Protected paths
                .anyRequest().hasAnyRole("USER", "ADMIN")
                .and()
                .formLogin()
                .loginPage("/login")
                .loginProcessingUrl("/userloginvalidate")
                .defaultSuccessUrl("/", true)
                .failureUrl("/login?error=true")
                .and()
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login")
                .deleteCookies("JSESSIONID")
                .and()
                .csrf().disable();

        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        return username -> {
            log.info("Attempting authentication for user: {}", username);
            User user = userService.getUserByUsername(username);

            if (user == null) {
                log.warn("Authentication failed: User not found: {}", username);
                throw new UsernameNotFoundException("User not found: " + username);
            }

            // Map DB Roles to Spring Security Roles
            String securityRole = "ROLE_ADMIN".equals(user.getRole()) ? "ADMIN" : "USER";

            log.info("Authentication successful for [{}]. Security role assigned: [{}]", user.getUsername(),
                    securityRole);

            return org.springframework.security.core.userdetails.User
                    .withUsername(user.getUsername())
                    .password(user.getPassword())
                    .roles(securityRole)
                    .build();
        };
    }
}
