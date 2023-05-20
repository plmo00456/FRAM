package com.main.utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

public class Utils {

	//httponly 쿠키 가져오는 메소드
	public static Optional<Cookie> getHttpOnlyCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(name)) {
                    return Optional.of(cookie);
                }
            }
        }
        return Optional.empty();
    }
	
	// 강제 json response 하는 메소드
	public void sendJsonResponse(HttpServletResponse response, Object result) {
	    Gson gson = new Gson();
	    String jsonResponse = gson.toJson(result);

	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");

	    try (PrintWriter out = response.getWriter()) {
	        out.print(jsonResponse);
	        out.flush();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	}
	
	// replaceXss
	public static String replaceXSS(String value) {
		if(value != null) {
			value = value.replaceAll("\\<", "&lt;").replaceAll("\\>", "&gt;").replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
		}
		return value;
	}
}
