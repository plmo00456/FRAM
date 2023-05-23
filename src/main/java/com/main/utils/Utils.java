package com.main.utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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
	
	// 용량 byte로 변환	10MB => 10 * 1024 * 1024
	public static long convertFileSizeToBytes(String fileSize) {
        String sizeValue = fileSize.substring(0, fileSize.length() - 2);
        String unit = fileSize.substring(fileSize.length() - 2).toUpperCase();

        switch (unit) {
            case "KB":
                return Long.parseLong(sizeValue) * 1024;
            case "MB":
                return Long.parseLong(sizeValue) * 1024 * 1024;
            case "GB":
                return Long.parseLong(sizeValue) * 1024 * 1024 * 1024;
            default:
                return -1;
        }
    }
	
	// url 파라미터 제거
	public static String removeParametersFromUrl(String urlString) throws Exception {
		try {
	        URL url = new URL(urlString);
	        URI uri = new URI(url.getProtocol(), url.getUserInfo(), url.getHost(), url.getPort(), url.getPath(), null, null);
	        return uri.toString();
		}catch(Exception e) {
	    	return urlString;
	    }
    }
	
	// url 인코딩
	public static URL createEncodedUrl(String imageUrl) throws URISyntaxException, MalformedURLException {
        URI uri = new URI(imageUrl);
        String[] segments = uri.getRawPath().split("/");
        StringBuilder encodedPathBuilder = new StringBuilder();

        for (String segment : segments) {
            if (!segment.isEmpty()) {
                encodedPathBuilder.append("/");
                encodedPathBuilder.append(URLEncoder.encode(segment, StandardCharsets.UTF_8).replaceAll("\\+", "%20"));
            }
        }

        String encodedQuery = uri.getRawQuery() == null ? null : URLEncoder.encode(uri.getRawQuery(), StandardCharsets.UTF_8)
                .replaceAll("\\+", "%20")
                .replaceAll("%3D", "=")
                .replaceAll("%26", "&");

        URI encodedUri = new URI(
                uri.getScheme(), uri.getUserInfo(), uri.getHost(), uri.getPort(),
                encodedPathBuilder.toString(), encodedQuery, uri.getFragment()
        );

        return encodedUri.toURL();
    }
}
