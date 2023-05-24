package com.main.Controller;

import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.main.JwtUtil.CustomUserDetails;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.utils.Utils;

import lombok.RequiredArgsConstructor;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {

	@Value("${jwt.access.token.expire}")
	private Integer accessTokenExpire;
	@Value("${jwt.refresh.token.expire}")
	private Integer refreshTokenExpire;
	@Value("${spring.servlet.multipart.max-file-size}")
    private String maxFileSize;
	
	private final JwtTokenProvider jwtTokenProvider;
	
    @ModelAttribute
    public void addAttributes(Model model, HttpServletRequest req, HttpServletResponse res) {
    	String accessToken = null;
		Cookie[] cookies = req.getCookies();
		if (cookies != null) {
		    for (Cookie cookie : cookies) {
		        if (cookie.getName().equals("accessToken")) {
		        	accessToken = cookie.getValue();
		            break;
		        }
		    }
		}
		
		if (accessToken != null && jwtTokenProvider.validateToken(accessToken)) {
			Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			model.addAttribute("userInfo",  ((CustomUserDetails)principal));
		} else if (accessToken != null && !jwtTokenProvider.validateToken(accessToken) ){
			Optional<Cookie> refreshTokenCookie = Utils.getHttpOnlyCookie(req, "refreshToken");
			if (refreshTokenCookie.isPresent()) {
				String refreshToken = refreshTokenCookie.get().getValue();
				if(jwtTokenProvider.validateToken(refreshToken)) {					
					try {
						String newAccessToken = jwtTokenProvider.generateNewAccessToken(refreshToken);
						Cookie myCookie = new Cookie("accessToken", newAccessToken);
				        myCookie.setMaxAge(accessTokenExpire); // 쿠키 유효 시간(초)
				        myCookie.setPath("/");
				        res.addCookie(myCookie);
						res.sendRedirect("/");
					} catch (Exception e) {
						model.addAttribute("userInfo", null);
					}
				}else {
					model.addAttribute("userInfo", null);
				}
			} else {
				model.addAttribute("userInfo", null);
			}
		}else {
			model.addAttribute("userInfo", null);
		}
    }
    
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<?> handleMaxUploadSizeExceededException(MaxUploadSizeExceededException e) {
    	Gson gson = new Gson();
        JsonObject result = new JsonObject();
		result.addProperty("status", "N");
		result.addProperty("msg", "이 파일은 제한된 크기(" + maxFileSize + ")를 초과하였기 때문에 업로드를 할 수 없습니다." );
        return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).header("Content-Type", "application/json").body(gson.toJson(result));
    }
}
