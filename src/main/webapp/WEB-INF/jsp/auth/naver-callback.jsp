<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<!doctype html>
<html lang="ko">
<head>
    <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
    <c:import url="/common/files" charEncoding="UTF-8"/>
</head>
<body>
<div></div>
<script type="text/javascript">
	var url = window.location.protocol + "//" + window.location.host;
    var naver_id_login = new naver_id_login("${naverClientId}", url + "/api/auth/oauth2/naver");
    naver_id_login.get_naver_userprofile("naverSignInCallback()");

    // 네이버 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function
    function naverSignInCallback() {
    	$.ajax({
    		url : "/api/auth/login/naver",
    		type: 'POST',
    		contentType: "application/json",
    	    data: JSON.stringify({
    	        "userId": naver_id_login.getProfileData('email'),
    	        "password": naver_id_login.getProfileData('id'),
    	        "name": naver_id_login.getProfileData('name'),
    	        "nickname": naver_id_login.getProfileData('nickname'),
    	        "provide": "naver"
    	    }),
    		success: function(data) {
    			document.cookie = 'accessToken=' + data.accessToken + ';path=/;max-age=' + data.accessExpire;
    			opener.parent.location.reload();
   				self.close();
    		},
    		error: function(error) {
    			opener.parent.loadingClose();
    			opener.parent.msgShow("로그인 중 오류가 발생했습니다.", "error");
    		}
    	});
    }

</script>
</body>
</html>