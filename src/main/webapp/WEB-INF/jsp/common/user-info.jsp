<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ page import="com.main.JwtUtil.CustomUserDetails" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    boolean isLoggedIn = authentication != null && !authentication.getName().equals("anonymousUser");
	CustomUserDetails user = null;
	if(isLoggedIn)
		user = (CustomUserDetails) authentication.getPrincipal();
%>