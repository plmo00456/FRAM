<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<div class="user-dim">
    <div class="login-layer user-layer layer">
        <div class="logo">
            <img src="/image/logo.png" alt="로고">
        </div>
        <div class="input-box">
            <input type="text" name="userId" maxlength="20" placeholder="아이디">
            <input type="password" name="password" maxlength="30" placeholder="비밀번호">
            <span class="login-err">아이디 혹은 비밀번호가 일치하지 않습니다</span>
            <input type="button" id="login-btn" class="login-btn" value="로그인">
        </div>
        <div class="find-pass">
            <a href="#">비밀번호를 잊어버리셨나요?</a>
            <span>계정이 없으시나요?<a href='javascript:document.querySelector(".register-layer-btn").click()'>회원가입</a></span>
        </div>
        <div class="hr">OR</div>
        <div class="sns-login">
            <div class="text">SNS로 간편 로그인 / 회원가입</div>
            <div class="sns-btns">
                <button id="naver_id_login">
                    <img src="/image/auth/naver_btn.png" alt="네이버 로그인">
                </button>
                <button id="kako_id_login">
                    <img src="/image/auth/kakao_btn.png" alt="카카오 로그인">
                </button>
                <button class="google" id="google_id_login">
				    <img src="/image/auth/google_btn.png" alt="구글 로그인">
				</button>
            </div>
        </div>
    </div>
    
    <div class="register-layer user-layer layer">
        <div class="logo">
            <img src="/image/logo.png" alt="로고">
        </div>
        <div class="input-box">
            <input type="text" name="userId" maxlength="20" placeholder="아이디">
            <input type="password" name="password" maxlength="30" placeholder="비밀번호">
            <input type="password" name="passwordConfirm" maxlength="30" placeholder="비밀번호 확인">
            <input type="text" name="name" maxlength="20" placeholder="이름">
            <span class="login-err">비밀번호가 일치하지 않습니다.</span>
            <div class="terms">
            	<strong>회원정보보호 및 대책</strong>
            	<br><br>
            	1. 개인정보 수집 목적 및 이용
            </div>
            <label class="terms-check-box">
            	<input type="checkbox" name="termsCheck"> 개인정보 수집이용에 동의합니다.
            </label>
            <input type="button" id="register-btn" class="register-btn" value="회원가입">
        </div>
    </div>
    
</div>

<script>
    var url = window.location.protocol + "//" + window.location.host;
	var naver_id_login = new naver_id_login("${naverClientId}", url+"/api/auth/oauth2/naver");
    var state = naver_id_login.getUniqState();
    naver_id_login.setDomain(url+"/");
    naver_id_login.setState(state);
    naver_id_login.setPopup();
    naver_id_login.init_naver_id_login();
    
    document.querySelector("#naver_id_login").addEventListener("click", function(){
    	showLoadingLayer();
    });
    
    function kakaoLogin() {
        Kakao.Auth.login({
          success: function (response) {
            Kakao.API.request({
              url: '/v2/user/me',
              success: function (response) {
            	  $.ajax({
              		url : "/api/auth/login/google",
              		type: 'POST',
              		contentType: "application/json",
              		async: false,
              	    data: JSON.stringify({
              	        "userId": response.kakao_account.email,
              	        "password": response.id,
              	        "name": response.kakao_account.profile.nickname,
              	        "nickname": response.kakao_account.profile.nickname,
              	        "provide": "kakao"
              	    }),
              		success: function(data) {
              			document.cookie = 'accessToken=' + data.accessToken + ';path=/;max-age=' + data.accessExpire;
              			location.reload();
              		},
              		error: function(error) {
              			loadingLayer(0);
              			msgShow("로그인 중 오류가 발생했습니다.", "error");
              		}
              	});
              },
              fail: function (error) {
            	  loadingLayer(0);
        			msgShow("로그인 중 오류가 발생했습니다.", "error");
              },
            })
          },
          fail: function (error) {
            console.log(error);
            loadingLayer(0);
  			msgShow("로그인 중 오류가 발생했습니다.", "error");
          },
        })
      }
    
    document.querySelector("#kako_id_login").addEventListener("click", function(){
    	loadingLayer(1);
    	kakaoLogin();
    });
    
    function handleCredentialResponse(response) {
    	const responsePayload = parseJwt(response.credential);
        $.ajax({
    		url : "/api/auth/login/google",
    		type: 'POST',
    		contentType: "application/json",
    		async: false,
    	    data: JSON.stringify({
    	        "userId": responsePayload.email,
    	        "password": responsePayload.sub,
    	        "name": responsePayload.name,
    	        "nickname": responsePayload.name,
    	        "provide": "google"
    	    }),
    		success: function(data) {
    			document.cookie = 'accessToken=' + data.accessToken + ';path=/;max-age=' + data.accessExpire;
    			location.reload();
    		},
    		error: function(error) {
    			loadingLayer(0);
      			msgShow("로그인 중 오류가 발생했습니다.", "error");
    		}
    	});
        loadingLayer(0);
    }
    function parseJwt (token) {
        var base64Url = token.split('.')[1];
        var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));

        return JSON.parse(jsonPayload);
    };
    function loadingLayer(mode) {
    	if(mode == "1"){    		
	        $(".dim").show();
	        $(".dim .loading-layer").show();
    	}else if(mode == "0"){
	        $(".dim").hide();
	        $(".dim .loading-layer").hide();
    	}
    }
    window.onload = function(){
    	Kakao.init('${kakaoClientId}');
	    google.accounts.id.initialize({
	      client_id: "${googleClientId}",
	      callback: handleCredentialResponse
	    });
	    google.accounts.id.renderButton(
	      document.getElementById("google_id_login"),
	      { theme: "outline", size: "large", shape: "circle", type: "icon", width: 100 }
	    );
	    document.getElementById("google_id_login").addEventListener("click", function () {
	    	loadingLayer(1);
	        google.accounts.id.prompt(handleCredentialResponse);
	    });
    }
</script>