package com.main.ApiController;

import java.util.Map;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.main.JwtUtil.CustomUserDetails;
import com.main.JwtUtil.JwtToken;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.service.UsersService;
import com.main.utils.Utils;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthApiController {
	
	@Value("${jwt.access.token.expire}")
	private Integer accessTokenExpire;
	@Value("${jwt.refresh.token.expire}")
	private Integer refreshTokenExpire;
	@Value("${naver.api.clientid}")
	private String naverClientId;

	private final JwtTokenProvider jwtTokenProvider;
	@Autowired
	private UsersService us;

	@PostMapping("/login")
	public ResponseEntity<JwtToken> loginSuccess(@RequestBody Map<String, String> loginForm, HttpServletResponse res) {
		JwtToken token = us.login(loginForm.get("userId"), loginForm.get("password"), res);
		return ResponseEntity.ok(token);
	}

	@PostMapping("/refresh")
	public ResponseEntity<String> refreshAccessToken(HttpServletRequest req, HttpServletResponse res) {
		Gson gson = new Gson();
		JsonObject result = new JsonObject();
		result.addProperty("status", "N");
		Optional<Cookie> refreshTokenCookie = Utils.getHttpOnlyCookie(req, "refreshToken");
		if (refreshTokenCookie.isPresent()) {
			String refreshToken = refreshTokenCookie.get().getValue();
			try {
				String newAccessToken = jwtTokenProvider.generateNewAccessToken(refreshToken);
				res.setHeader("Authorization", "Bearer " + newAccessToken);
				JwtToken token = new JwtToken("Bearer", newAccessToken, refreshToken, accessTokenExpire);
				result.addProperty("status", "Y");
				result.add("token", gson.toJsonTree(token).getAsJsonObject());
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			} catch (Exception e) {
				result.addProperty("msg", "Expired JWT Token");
				result.addProperty("code", "001");
				e.fillInStackTrace();
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			}
		} else {
			result.addProperty("msg", "Invalid JWT Token");
			result.addProperty("code", "002");
			return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
		}
	}
	
	@PostMapping("/getme")
	public ResponseEntity<String> GetUserInfo(HttpServletRequest req, HttpServletResponse res) {
		Gson gson = new Gson();
		JsonObject result = new JsonObject();
		String accessToken = jwtTokenProvider.resolveToken(req);
		
		Authentication auth = jwtTokenProvider.getAuthentication(accessToken);
		
		result.addProperty("status", "N");
		boolean validateToken = jwtTokenProvider.validateToken(accessToken);
		if (accessToken != null && validateToken) {
			try {
				auth = jwtTokenProvider.getAuthentication(accessToken);
				
				result.addProperty("status", "Y");
				result.add("user",  gson.toJsonTree((CustomUserDetails) auth.getPrincipal()).getAsJsonObject());
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			} catch (Exception e) {
				result.addProperty("msg", "Expired JWT Token");
				result.addProperty("code", "001");
				e.fillInStackTrace();
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			}
		} else {
			result.addProperty("msg", "Invalid JWT Token");
			result.addProperty("code", "002");
			return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
		}
	}

	@GetMapping(value="/oauth2/naver")
	public ModelAndView NaverLoginCallback(ModelAndView mav, Model model) {
		mav.addObject("naverClientId", naverClientId);
		mav.setViewName("auth/naver-callback");
        return mav;
    }
	
	@PostMapping(value="/login/naver")
	public ResponseEntity<JwtToken> NaverLoginProc(@RequestBody Map<String, String> loginForm, HttpServletResponse res) {
		
		JwtToken token = us.emailLogin(loginForm.get("userId"), loginForm.get("password"), res);
		return ResponseEntity.ok(token);
    }

}
