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
    			alert("�α��� �� ������ �߻��߽��ϴ�.");
    		}
    	});
    }

</script>
</body>
</html>