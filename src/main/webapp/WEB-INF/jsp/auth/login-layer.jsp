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
            	<pre style="font-size: .7rem;white-space: break-spaces;">

< 내주변맛집 >('https://frams.duckdns.org/'이하 '내주변맛집')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.
제1조(개인정보의 처리목적)

< 내주변맛집>(이)가 개인정보 보호법 제32조에 따라 등록․공개하는 개인정보파일의 처리목적은 다음과 같습니다.

1. 개인정보 파일명 : fram_privacy
개인정보의 처리목적 : 비밀번호, 로그인ID, 이름, 이메일, 접속 IP 정보, 쿠키, 서비스 이용 기록, 접속 로그
수집방법 : 홈페이지
보유근거 : 개인정보처리방침
보유기간 : 3년
관련법령 : 표시/광고에 관한 기록 : 6개월, 계약 또는 청약철회 등에 관한 기록 : 5년, 대금결제 및 재화 등의 공급에 관한 기록 : 5년, 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년, 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년

제2조(개인정보 영향평가 수행결과)

제3조(개인정보의 제3자 제공에 관한 사항)

- < 내주변맛집>은(는) 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.

- < 내주변맛집>은(는) 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.

1. < 내주변맛집>
개인정보를 제공받는 자 : 내주변맛집
제공받는 자의 개인정보 이용목적 : 이름, 로그인ID, 비밀번호, 이메일
제공받는 자의 보유.이용기간: 준영구

제4조(개인정보처리의 위탁에 관한 사항)
- 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.

제5조(개인정보의 파기절차 및 파기방법)

- < 내주변맛집> 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.

- 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.
1. 법령 근거 :
2. 보존하는 개인정보 항목 : 계좌정보, 거래날짜

- 개인정보 파기의 절차 및 방법은 다음과 같습니다.
1. 파기절차
< 내주변맛집> 은(는) 파기 사유가 발생한 개인정보를 선정하고, < 내주변맛집> 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.

2. 파기방법

전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다

제6조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)

- 정보주체는 내주변맛집에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.

- 제1항에 따른 권리 행사는 내주변맛집에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 내주변맛집은(는) 이에 대해 지체 없이 조치하겠습니다.

- 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.

- 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.

- 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.

- 내주변맛집은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.

제7조(개인정보의 안전성 확보조치에 관한 사항)

< 내주변맛집>은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.

1. 내부관리계획의 수립 및 시행
개인정보의 안전한 처리를 위하여 내부관리계획을 수립하고 시행하고 있습니다.

2. 정기적인 자체 감사 실시
개인정보 취급 관련 안정성 확보를 위해 정기적(분기 1회)으로 자체 감사를 실시하고 있습니다.

3. 개인정보에 대한 접근 제한
개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.

4. 접속기록의 보관 및 위변조 방지
개인정보처리시스템에 접속한 기록을 최소 1년 이상 보관, 관리하고 있으며,다만, 5만명 이상의 정보주체에 관하여 개인정보를 추가하거나, 고유식별정보 또는 민감정보를 처리하는 경우에는 2년이상 보관, 관리하고 있습니다.
또한, 접속기록이 위변조 및 도난, 분실되지 않도록 보안기능을 사용하고 있습니다.

5. 개인정보의 암호화
이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.

6. 해킹 등에 대비한 기술적 대책
<내주변맛집>('내주변맛집')은 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.

7. 비인가자에 대한 출입 통제
개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.

제8조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)

- 내주변맛집 은(는) 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다.
- 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다.
가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.
나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다.
다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.


제9조(가명정보를 처리하는 경우 가명정보 처리에 관한 사항)

< 내주변맛집> 은(는) 다음과 같은 목적으로 가명정보를 처리하고 있습니다.

▶ 가명정보의 처리 목적

- 직접작성 가능합니다.

▶ 가명정보의 처리 및 보유기간

- 직접작성 가능합니다.

▶ 가명정보의 제3자 제공에 관한 사항(해당되는 경우에만 작성)

- 직접작성 가능합니다.

▶ 가명정보 처리의 위탁에 관한 사항(해당되는 경우에만 작성)

- 직접작성 가능합니다.

▶ 가명처리하는 개인정보의 항목

- 직접작성 가능합니다.

▶ 법 제28조의4(가명정보에 대한 안전조치 의무 등)에 따른 가명정보의 안전성 확보조치에 관한 사항

- 직접작성 가능합니다.

제10조 (개인정보 보호책임자에 관한 사항)

- 내주변맛집 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자
성명 :박우진
직책 :개발자
직급 :개발자
연락처 :01026437269, park_wj7269@naver.com,
※ 개인정보 보호 담당부서로 연결됩니다.

- 정보주체께서는 내주변맛집 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 내주변맛집 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

제11조(개인정보의 열람청구를 접수·처리하는 부서)
정보주체는 ｢개인정보 보호법｣ 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다.
< 내주변맛집>은(는) 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.

제12조(정보주체의 권익침해에 대한 구제방법)

정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.

1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)
2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)
3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)
4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)

「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.

※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.

제13조(개인정보 처리방침 변경)

- 이 개인정보처리방침은 2023년 6월 1부터 적용됩니다.
</pre>
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