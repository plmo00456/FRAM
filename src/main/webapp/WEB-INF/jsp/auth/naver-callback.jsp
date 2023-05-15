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
    var naver_id_login = new naver_id_login("${naverClientId}", "http://localhost:8080/api/auth/oauth2/naver");
    // ���� ��ū �� ���
    //alert(naver_id_login.oauthParams.access_token);
    // ���̹� ����� ������ ��ȸ
    naver_id_login.get_naver_userprofile("naverSignInCallback()");

    // ���̹� ����� ������ ��ȸ ���� ������ ������ ó���� callback function
    function naverSignInCallback() {
    	var div = document.querySelector("div");
    	console.log(naver_id_login);
    	var str = '';
    	str += naver_id_login.getProfileData('email') + "<br>";
    	str += naver_id_login.getProfileData('nickname') + "<br>";
    	str += naver_id_login.getProfileData('age') + "<br>";
    	str += naver_id_login.getProfileData('id') + "<br>";
    	str += naver_id_login.getProfileData('birthday') + "<br>";
    	str += naver_id_login.getProfileData('gender') + "<br>";
    	str += naver_id_login.getProfileData('mobile') + "<br>";
    	str += naver_id_login.getProfileData('name') + "<br>";
    	div.innerHTML = str;
    	
    	$.ajax({
    		url : "/api/auth/login/naver",
    		type: 'POST',
    		contentType: "application/json",
    	    data: JSON.stringify({
    	        "userId": naver_id_login.getProfileData('email'),
    	        "password": naver_id_login.getProfileData('id')
    	    }),
    		success: function(data) {
    			document.cookie = 'accessToken=' + data.accessToken + ';path=/;max-age=' + data.accessExpire;
    			self.close();
    		},
    		error: function(error) {
    			alert("�α��� �� ������ �߻��߽��ϴ�.");
    		}
    	});
    }

</script>
</body>
</html>