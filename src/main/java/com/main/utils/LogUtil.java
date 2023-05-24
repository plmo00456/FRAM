package com.main.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.main.JwtUtil.CustomUserDetails;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.service.UserActivityLogService;
import com.main.service.UsersService;
import com.main.vo.Users;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class LogUtil {
	
	@Autowired
	private UsersService us;
	
	@Autowired
	private UserActivityLogService uals;
	
	private final JwtTokenProvider jwtTokenProvider;
	
	public void setActivityLog(String type, HttpServletRequest req, HttpServletResponse res) {
	    String logUserIp = req.getRemoteAddr();
	    String url = req.getRequestURI();
	    String logUserAgent = res.getHeader("User-Agent");
	    Long logUserSeq = getUserSeq(req);

	    StringBuilder data = new StringBuilder();
	    Enumeration<String> paramKeys = req.getParameterNames();
	    boolean first = true;

	    while (paramKeys.hasMoreElements()) {
	        String key = paramKeys.nextElement();
	        String value = req.getParameter(key);

	        if ("password".equalsIgnoreCase(key) || "pw".equalsIgnoreCase(key)) {
	            continue;
	        }

	        if (!first) {
	            data.append("&");
	        } else {
	            first = false;
	        }

	        data.append(key).append("=").append(value);
	    }

	    try {
	        InputStream inputStream = req.getInputStream();
	        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
	        String line;
	        StringBuilder requestBody = new StringBuilder();
	        while ((line = reader.readLine()) != null) {
	            requestBody.append(line);
	        }

	        if (requestBody.length() > 0) {
	            Gson gson = new Gson();
	            JsonObject jsonObject = gson.fromJson(requestBody.toString(), JsonObject.class);
	            jsonObject.remove("password");
	            jsonObject.remove("pw");

	            if (data.length() > 0) {
	                data.append("&");
	            }
	            
	            data.append(jsonObject.toString());
	        }

	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    String dataString = data.toString();

	    uals.logActivity(logUserIp, logUserSeq, url, type, dataString, logUserAgent);
	}

	public Long getUserSeq(HttpServletRequest req) {
		Optional<Cookie> accessTokenCookie = Utils.getHttpOnlyCookie(req, "accessToken");
		String accessToken = "";
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
								return seq;
							}else {
								return null;
							}
						}else {
							return null;
						}
					} catch (Exception e) {
						return null;
					}
				} else {
					return null;
				}
			}catch(Exception e) {
				return null;
			}
		}else {
			return null;
		}
		
	}
}
