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
            	<strong>[내주변 맛집(FRAM) 개인정보 처리방침]</strong><br>
				<br>
				<strong>제 1 조 (개인정보의 처리목적)</strong><br>
				"내주변 맛집(FRAM)"(이하 'FRAM')은 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고, 처리에 관한 사항을 안내하고자 이 개인정보 처리방침을 작성합니다. 이 처리방침은 관계 법령 및 지침에 따라 변경될 수 있습니다.<br>
				<br>
				<strong>제 2 조 (개인정보의 처리 및 보유기간)</strong><br>
				FRAM은 원칙적으로 개인정보 보유기간의 기간이 만료되거나 처리 목적 달성 시 즉시 파기합니다.<br>
				<br>
				<strong>제 3 조 (개인정보의 제공 및 위탁)</strong><br>
				FRAM은 수집된 개인정보를 제3자에게 제공하지 않습니다. 당사가 제공하는 서비스를 향상하기 위해 개인정보를 외부 전문 업체에 위탁 처리할 경우에는 위탁 대상자 및 처리 목적을 사용자에게 통지하고 동의를 얻어야 합니다.<br>
				<br>
				<strong>제 4 조 (서비스 이용해지)</strong><br>
				지원자가 FRAM 서비스를 해지하고자 하는 경우, 개인정보 보유기간의 최종 일까지 개인정보를 파기하며, 순수화된 정보를 삭제하거나 이용자의 정보를 식별할 수 없도록 처리하고 삭제합니다.<br>
				<br>
				<strong>제 5 조 (개인정보 자동 수집 장치의 설치, 운영 및 그 거부에 관한 사항)</strong><br>
				FRAM은 개인화되고 맞춤화된 서비스를 제공하기 위해 이용자의 정보를 저장하고 조회하는 '쿠키(cookie)'를 사용할 수 있습니다.<br>
				<br>
				<strong>제 6 조 (개인정보 보호 책임자)</strong><br>
				FRAM은 개인정보 처리에 관한 업무를 총괄해서 책임지고 연락처를 게시하여 이용자의 쉬운 연락 사항을 처리합니다. 이용자는 FRAM의 서비스를 이용하시며 발생한 모든 개인정보 보호 관련 민원을 개인정보 보호 책임자 혹은 담당부서로 상담하실 수 있습니다.<br>
				<br>
				개인정보 보호 책임자<br>
				<br>
				성명: 박우진<br>
				연락처: park_wj7269@naver.com<br>
				<br>
				<strong>제 7 조 (권익침해 구제방법)</strong><br>
				이용자는 개인정보 보호 문제에 대한 구제를 받기 위해 행정처분에 대한 신청 등을 관계 기관에 제기할 수 있습니다.<br>
				<br>
				<strong>제 8 조 (변경사항)</strong><br>
				FRAM은 관련 법령 및 정책의 변경사항에 따라 개인정보 처리방침을 수정할 수 있으며, 변경된 방침은 적용일 로부터 시행됩니다. 변경된 처리방침은 시행일 가최소 7일 전에 서비스 내 공지하고 사용자에게 안내합니다.<br>
				<br>
				본 개인정보 처리방침은 2023년 06월 01일부터 적용됩니다.<br>
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