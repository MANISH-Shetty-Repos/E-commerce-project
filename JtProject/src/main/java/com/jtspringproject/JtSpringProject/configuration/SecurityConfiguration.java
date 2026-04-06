package com.jtspringproject.JtSpringProject.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
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
    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    public SecurityConfiguration(userService userService, org.springframework.security.crypto.password.PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    // Chain 1: Admin Area
    @Bean
    @Order(1)
    public SecurityFilterChain adminFilterChain(HttpSecurity http) throws Exception {
        http
                .antMatcher("/admin/**")
                .securityContext()
                    .securityContextRepository(adminSecurityContextRepository())
                .and()
                .authenticationProvider(adminAuthenticationProvider())
                .authorizeRequests()
                .antMatchers("/admin/login", "/admin/products/bulk").permitAll()
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
                .securityContext()
                    .securityContextRepository(userSecurityContextRepository())
                .and()
                .authenticationProvider(userAuthenticationProvider())
                .authorizeRequests()
                // Public paths
                .antMatchers("/", "/user/products", "/login", "/register", "/newuserregister", "/test", "/test2").permitAll()
                .antMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                .antMatchers("/resources/**", "/static/**", "/css/**", "/js/**", "/images/**", "/favicon.ico")
                .permitAll()
                // Protected paths
                .anyRequest().hasRole("USER")
                .and()
                .formLogin()
                .loginPage("/login")
                .loginProcessingUrl("/userloginvalidate")
                .defaultSuccessUrl("/", true)
                .failureUrl("/login?error=true")
                .and()
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .deleteCookies("JSESSIONID")
                .and()
                .csrf().disable();

        return http.build();
    }

    @Bean
    public org.springframework.security.web.context.SecurityContextRepository adminSecurityContextRepository() {
        org.springframework.security.web.context.HttpSessionSecurityContextRepository repo = new org.springframework.security.web.context.HttpSessionSecurityContextRepository();
        repo.setSpringSecurityContextKey("ADMIN_SECURITY_CONTEXT");
        return repo;
    }

    @Bean
    public org.springframework.security.web.context.SecurityContextRepository userSecurityContextRepository() {
        org.springframework.security.web.context.HttpSessionSecurityContextRepository repo = new org.springframework.security.web.context.HttpSessionSecurityContextRepository();
        repo.setSpringSecurityContextKey("USER_SECURITY_CONTEXT");
        return repo;
    }

    @Bean
    public org.springframework.security.authentication.dao.DaoAuthenticationProvider adminAuthenticationProvider() {
        org.springframework.security.authentication.dao.DaoAuthenticationProvider authProvider = new org.springframework.security.authentication.dao.DaoAuthenticationProvider();
        authProvider.setUserDetailsService(username -> {
            User user = userService.getUserByUsername(username);
            if (user == null || !"ROLE_ADMIN".equals(user.getRole())) {
                log.warn("Admin login attempt failed for user: {}", username);
                throw new UsernameNotFoundException("Admin not found: " + username);
            }
            return org.springframework.security.core.userdetails.User
                    .withUsername(user.getUsername())
                    .password(user.getPassword())
                    .roles("ADMIN")
                    .build();
        });
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }

    @Bean
    public org.springframework.security.authentication.dao.DaoAuthenticationProvider userAuthenticationProvider() {
        org.springframework.security.authentication.dao.DaoAuthenticationProvider authProvider = new org.springframework.security.authentication.dao.DaoAuthenticationProvider();
        authProvider.setUserDetailsService(username -> {
            User user = userService.getUserByUsername(username);
            if (user == null || "ROLE_ADMIN".equals(user.getRole())) {
                log.warn("User login attempt failed for user (or Admin tried user login): {}", username);
                throw new UsernameNotFoundException("User not found: " + username);
            }
            return org.springframework.security.core.userdetails.User
                    .withUsername(user.getUsername())
                    .password(user.getPassword())
                    .roles("USER")
                    .disabled(user.isBlocked())
                    .build();
        });
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }
}
