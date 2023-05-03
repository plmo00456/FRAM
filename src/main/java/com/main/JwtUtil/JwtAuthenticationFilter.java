package com.main.JwtUtil;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
 
    private final JwtTokenProvider jwtTokenProvider;
    
 
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
    	String token = resolveToken(request);
    	if(token == null) {    		
    		Cookie[] cookies = request.getCookies();
    		if (cookies != null) {
    			for (Cookie cookie : cookies) {
    				if (cookie.getName().equals("accessToken")) {
    					token = cookie.getValue();
    					break;
    				}
    			}
    		}
    	}
    	
    	boolean validateToken = jwtTokenProvider.validateToken(token);
    	token = validateToken ? token : null;
        if (token != null && validateToken) {
            Authentication authentication = jwtTokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        filterChain.doFilter(request, response);
    }
 
    // Request Header 에서 토큰 정보 추출
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}