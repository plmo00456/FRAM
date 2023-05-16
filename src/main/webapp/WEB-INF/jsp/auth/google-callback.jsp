<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<html lang="en">
<head>
   <script src="https://accounts.google.com/gsi/client" async defer></script>
   <script src="https://apis.google.com/js/client:platform.js" async defer></script>
</head>
   <body>
	<button class="g-signin"
        data-clientid="${googleClientId}"
        data-theme="dark">
    </button>
	<script>
	  function handleCredentialResponse(response) {
	     const responsePayload = parseJwt(response.credential);
	
	     console.log("ID: " + responsePayload.sub);
	     console.log('Full Name: ' + responsePayload.name);
	     console.log('Given Name: ' + responsePayload.given_name);
	     console.log('Family Name: ' + responsePayload.family_name);
	     console.log("Image URL: " + responsePayload.picture);
	     console.log("Email: " + responsePayload.email);
	  }
	  function parseJwt (token) {
	    var base64Url = token.split('.')[1];
	    var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
	    var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
	        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
	    }).join(''));

	    return JSON.parse(jsonPayload);
	};
	</script>
   </body>
</html>