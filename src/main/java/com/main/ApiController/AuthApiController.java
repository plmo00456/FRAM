package com.main.ApiController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.main.JwtUtil.CustomUserDetails;
import com.main.JwtUtil.JwtToken;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.service.FileMasterService;
import com.main.service.UsersService;
import com.main.utils.LocalDateTimeSerializer;
import com.main.utils.LogUtil;
import com.main.utils.Utils;
import com.main.vo.FileMaster;
import com.main.vo.Users;

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
	@Value("${google.api.clientid}")
	private String googleClientId;
	@Value("${file.mapping.dir}")
	private String fileMappingDir;

	private final JwtTokenProvider jwtTokenProvider;
	
	@Autowired
	private UsersService us;
	
	@Autowired
	private FileMasterService fs;
	
	@Autowired
	private LogUtil logUtil;

	@PostMapping("/login")
	public ResponseEntity<JwtToken> loginSuccess(@RequestBody Map<String, String> loginForm, HttpServletResponse res, HttpServletRequest req) {
		try {
			logUtil.setActivityLog("select", req, res);
		}catch(Exception e) {}
		
		JwtToken token = us.login(loginForm.get("userId"), loginForm.get("password"), res);
		return ResponseEntity.ok(token);
	}
	
	@PostMapping("/register")
	public ResponseEntity<String> registerSuccess(@RequestBody Map<String, String> registerForm, HttpServletResponse res, HttpServletRequest req) {
		try {
			logUtil.setActivityLog("select, insert", req, res);
		}catch(Exception e) {}
		
		Gson gson = new Gson();
		JwtToken token = us.register(registerForm.get("userId"), registerForm.get("password"),
				registerForm.get("name"), res);
		JsonObject result = new JsonObject();
		if(token != null) {
			JsonElement jToken = gson.toJsonTree(token);
        	result.addProperty("status", "Y");        	
        	result.add("token", jToken);
		}else {
			result.addProperty("status", "N");
			result.addProperty("msg", "회원가입 중 오류가 발생했습니다.<br>관리자에게 문의해주세요");
		}
		return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
	}

	@PostMapping("/refresh")
	public ResponseEntity<String> refreshAccessToken(HttpServletRequest req, HttpServletResponse res) {
		try {
			logUtil.setActivityLog("select", req, res);
		}catch(Exception e) {}
		
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
	
	@PostMapping("/getMe")
	public ResponseEntity<String> getMe(HttpServletRequest req, HttpServletResponse res) {
		try {
			logUtil.setActivityLog("select", req, res);
		}catch(Exception e) {}
		
		Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
                .create();
		JsonObject result = new JsonObject();
		Optional<Cookie> accessTokenCookie = Utils.getHttpOnlyCookie(req, "accessToken");
		String accessToken = "";
		result.addProperty("status", "N");
		if (accessTokenCookie.isPresent()) {
			try {				
				accessToken = accessTokenCookie.get().getValue();
				Authentication auth = jwtTokenProvider.getAuthentication(accessToken);
				boolean validateToken = jwtTokenProvider.validateToken(accessToken);
				if (accessToken != null && validateToken) {
					try {
						auth = jwtTokenProvider.getAuthentication(accessToken);
						
						result.addProperty("status", "Y");
						Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
						Users userInfo = ((CustomUserDetails)principal).getUser();
						userInfo.setPassword("");
						if(userInfo.getProfileImage() != null) {
							userInfo.getProfileImage().setFilepath(fileMappingDir);
							userInfo.getProfileImage().setOriFilename("");
						}
						result.add("user",  gson.toJsonTree(userInfo).getAsJsonObject());
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					} catch (Exception e) {
						e.printStackTrace();
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
			}catch(Exception e) {
				result.addProperty("msg", "Invalid JWT Token");
				result.addProperty("code", "002");
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			}
		}else {
			result.addProperty("msg", "Invalid JWT Token");
			result.addProperty("code", "002");
			return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
		}
	}

	@GetMapping(value="/oauth2/naver")
	public ModelAndView NaverLoginCallback(ModelAndView mav, Model model, HttpServletRequest req, HttpServletResponse res) {
		try {
			logUtil.setActivityLog("select", req, res);
		}catch(Exception e) {}
		
		mav.addObject("naverClientId", naverClientId);
		mav.setViewName("auth/naver-callback");
        return mav;
    }
	
	@PostMapping(value="/login/naver")
	public ResponseEntity<JwtToken> NaverLoginProc(@RequestBody Map<String, String> loginForm, HttpServletRequest req, HttpServletResponse res) {
		try {
			logUtil.setActivityLog("select", req, res);
		}catch(Exception e) {}
		
		Users user = new Users();
		user.setEmail(loginForm.get("userId"));
		user.setPassword(loginForm.get("password"));
		user.setName(loginForm.get("name"));
		user.setNickname(loginForm.get("nickname"));
		user.setProvide(loginForm.get("provide"));
		
		JwtToken token = us.emailLogin(user, res);
		return ResponseEntity.ok(token);
    }
	
	@PostMapping(value="/login/google")
	public ResponseEntity<JwtToken> GoogleLoginProc(@RequestBody Map<String, String> loginForm, HttpServletRequest req, HttpServletResponse res) {
		try {
			logUtil.setActivityLog("select", req, res);
		}catch(Exception e) {}
		
		Users user = new Users();
		user.setEmail(loginForm.get("userId"));
		user.setPassword(loginForm.get("password"));
		user.setName(loginForm.get("name"));
		user.setNickname(loginForm.get("nickname"));
		user.setProvide(loginForm.get("provide"));
		
		JwtToken token = us.emailLogin(user, res);
		return ResponseEntity.ok(token);
    }
	
	@PostMapping(value="/update")
	public ResponseEntity<String> update(@RequestParam HashMap loginForm, HttpServletRequest req,
			HttpServletResponse res, @RequestParam(name="profile-image", required=false) MultipartFile imageFile) {
		try {
			logUtil.setActivityLog("update", req, res);
		}catch(Exception e) {}
		
		Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
                .create();
		JsonObject result = new JsonObject();
		Optional<Cookie> accessTokenCookie = Utils.getHttpOnlyCookie(req, "accessToken");
		String accessToken = "";
		result.addProperty("status", "N");
		if (accessTokenCookie.isPresent()) {
			try {				
				accessToken = accessTokenCookie.get().getValue();
				Authentication auth = jwtTokenProvider.getAuthentication(accessToken);
				boolean validateToken = jwtTokenProvider.validateToken(accessToken);
				if (accessToken != null && validateToken) {
					try {
						auth = jwtTokenProvider.getAuthentication(accessToken);
						
						Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
						CustomUserDetails userInfo = ((CustomUserDetails)principal);
						Long seq = userInfo.getSeq();
						if(seq != null && userInfo != null) {
							Optional<Users> user = us.getUser(userInfo.getSeq());
							if(user.isPresent()) {
								Users users = user.get();
								if(imageFile != null) {									
									FileMaster savedFile = fs.saveFile(imageFile, seq, res) ;
									if(savedFile != null)
										users.setProfileImage(savedFile);
								}
								if(!"".equals(loginForm.get("name")) && loginForm.get("name") != null)
									users.setName((loginForm.get("name")+"").trim());
								if(!"".equals(loginForm.get("nickname")) && loginForm.get("nickname") != null)
									users.setNickname((loginForm.get("nickname")+"").trim());
								
								us.updateUser(seq, users);
								result.addProperty("status", "Y");
							}else {
								throw new Exception("오류");
							}
						}else {
							throw new Exception("오류");
						}
						
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					} catch (Exception e) {
						e.printStackTrace();
						result.addProperty("msg", "오류가 발생했습니다.<br>관리자에게 문의해주세요.");
						result.addProperty("code", "001");
						e.fillInStackTrace();
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					}
				} else {
					result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
					result.addProperty("code", "002");
					return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
				}
			}catch(Exception e) {
				result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
				result.addProperty("code", "002");
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			}
		}else {
			result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
			result.addProperty("code", "002");
			return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
		}
    }

}
