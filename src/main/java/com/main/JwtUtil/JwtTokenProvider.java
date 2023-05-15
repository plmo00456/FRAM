package com.main.JwtUtil;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.openqa.selenium.devtools.v100.fetch.model.AuthRequired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtTokenProvider {
 
	@Value("${jwt.access.token.expire}")
	private Integer accessTokenExpire;
	@Value("${jwt.refresh.token.expire}")
	private Integer refreshTokenExpire;
	private final CustomUserDetailsService userDetailsService;
    private final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
 
    // 유저 정보를 가지고 AccessToken, RefreshToken 을 생성하는 메서드
    public JwtToken generateToken(Authentication authentication, HttpServletResponse res) {
        // 권한 가져오기
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));
        
        long now = (new Date()).getTime();
        // Access Token 생성
        Date accessTokenExpiresIn = new Date(now + accessTokenExpire);
        String accessToken = Jwts.builder()
                .setSubject(authentication.getName())
                .claim("auth", authorities.equals("") ? "ROLE_USER" : authorities)
                .setExpiration(accessTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
 
        // Refresh Token 생성
        String refreshToken = Jwts.builder()
        		.setSubject(authentication.getName())
                .setExpiration(new Date(now + refreshTokenExpire))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
        
        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setMaxAge(refreshTokenExpire); // 쿠키 만료 시간 설정
        refreshTokenCookie.setPath("/"); // 쿠키의 경로 설정
        // refreshTokenCookie.setSecure(true); // HTTPS를 사용할 경우 활성화
        res.addCookie(refreshTokenCookie);
 
        return JwtToken.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .accessExpire(accessTokenExpire)
                .build();
    }
 
    // JWT 토큰을 복호화하여 토큰에 들어있는 정보를 꺼내는 메서드
    public Authentication getAuthentication(String accessToken) {
        // 토큰 복호화
        Claims claims = parseClaims(accessToken);
 
        if (claims.get("auth") == null) {
            throw new RuntimeException("권한 정보가 없는 토큰입니다.");
        }
 
        // 클레임에서 권한 정보 가져오기
        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get("auth").toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());
        
        // UserDetails 객체를 만들어서 Authentication 리턴
        UserDetails principal = userDetailsService.loadUserByUsername(claims.getSubject());
        
        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
    }
 
    // 토큰 정보를 검증하는 메서드
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
            //System.out.println("Invalid JWT Token" + e);
        } catch (ExpiredJwtException e) {
            //System.out.println("Expired JWT Token" + e);
        } catch (UnsupportedJwtException e) {
            //System.out.println("Unsupported JWT Token" + e);
        } catch (IllegalArgumentException e) {
            //System.out.println("JWT claims string is empty." + e);
        }
        return false;
    }
 
    private Claims parseClaims(String accessToken) {
        try {
            return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }
    
    public String generateNewAccessToken(String refreshToken) {
        if (!validateToken(refreshToken)) {
            throw new IllegalArgumentException("Invalid refresh token.");
        }

        Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(refreshToken).getBody();
        String userId = claims.getSubject();
        UserDetails userDetails = userDetailsService.loadUserByUsername(userId);
        Date now = new Date();
        Date validity = new Date(now.getTime() + accessTokenExpire);
        Collection<? extends GrantedAuthority> auth = userDetails.getAuthorities();
        
        return Jwts.builder()
                .setSubject(userDetails.getUsername())
                .setIssuedAt(now)
                .claim("auth", auth.size() == 0 ? "ROLE_USER" : auth)
                .setExpiration(validity)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }
    
    public String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}