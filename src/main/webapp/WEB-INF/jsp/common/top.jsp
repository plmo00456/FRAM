<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}" />
<div class="top">
	<div class="container">
		<div class="logo">
			<img src="/image/logo.png" alt="로고">
		</div>
		<div class="links">
			<div class="menu">
				<c:forEach var="item" items="${menu}" varStatus="status">
					<c:if test="${path eq item.link}">
					    <a class="current" href="${item.link}">${item.name}</a>
					</c:if>
					<c:if test="${path ne item.link}">
					    <a href="${item.link}">${item.name}</a>
					</c:if>
				</c:forEach>
			</div>
			<div class="login">
				<c:if test="${userInfo ne null }">
					<div class="user-box" id="user-box">
						<c:if test="${empty userInfo.nickname}">
							<p class="user-icon">${fn:substring(userInfo.name,0,1)}</p>
							<p class="user-nickname">${userInfo.name}</p>
						</c:if>
						<c:if test="${not empty userInfo.nickname}">
							<p class="user-icon">${fn:substring(userInfo.nickname,0,1)}</p>
							<p class="user-nickname">${userInfo.nickname}</p>
						</c:if>
						<nav id="nav-dropdown" class="nav-dropdown">
							<ul>
								<li><a href="#" id="mypage-btn"><i class="fa-solid fa-user"></i>&nbsp;&nbsp;내정보</a></li>
								<li><a href="#" class="logout-btn" id="logout-btn"><i class="fa-solid fa-right-from-bracket"></i>&nbsp;&nbsp;로그아웃</a></li>
							</ul>
						</nav>
					</div>
				</c:if>
				<c:if test="${userInfo eq null }">
					<div class="login-layer-btn"><i class="fa-solid fa-right-to-bracket"></i></div>
					<div class="register-layer-btn"><i class="fa-solid fa-user-plus"></i></div>
				</c:if>
			</div>
		</div>
	</div>
</div>
<c:import url="/auth/login" charEncoding="UTF-8">
</c:import>

<script>
	<c:if test="${userInfo eq null}">
	document.querySelector(".login-layer-btn").addEventListener("click", function() {
		$(".user-dim").css("display", "flex").hide().fadeIn("fast", function() {
			$(".user-dim .login-layer").css("display", "flex").hide().fadeIn();
			document.querySelector(".login-layer input[name=userId]").focus();
		});
	});
	document.querySelector(".register-layer-btn").addEventListener("click", function() {
		if (!$(".user-dim").is(':visible')) {
			$(".user-dim").css("display", "flex").hide().fadeIn("fast",function() {
				$(".user-dim .register-layer").css("display", "flex").hide().fadeIn();
				document.querySelector(".register-layer input[name=userId]").focus();
			});
		} else {
			$(".user-dim .login-layer").hide();
			$(".user-dim .register-layer").css("display","flex").hide().fadeIn();
			document.querySelector(".register-layer input[name=userId]").focus();
		}
	});

	document.querySelector(".login-layer input[name=userId]").addEventListener("keydown",function() {
		var idInput = document.querySelector(".login-layer input[name=userId]");
		idInput.classList.remove("required");
	});

	document.querySelector(".login-layer input[name=userId]").addEventListener("blur",function() {
		var idInput = document.querySelector(".login-layer input[name=userId]");
		if (idInput.value == "")
			idInput.classList.add("required");
	});

	document.querySelector(".login-layer input[name=password]").addEventListener("keydown",function() {
		var pwInput = document.querySelector(".login-layer input[name=password]");
		pwInput.classList.remove("required");
	});

	document.querySelector(".login-layer input[name=password]").addEventListener("blur",function() {
		var pwInput = document.querySelector(".login-layer input[name=password]");
		if (pwInput.value == "")
			pwInput.classList.add("required");
	});

	document.querySelector(".register-layer input[name=userId]").addEventListener("keydown",function() {
		var idInput = document.querySelector(".register-layer input[name=userId]");
		idInput.classList.remove("required");
	});

	document.querySelector(".register-layer input[name=userId]").addEventListener("blur",function() {
		var idInput = document.querySelector(".register-layer input[name=userId]");
		if (idInput.value == "")
			idInput.classList.add("required");
	});

	document.querySelector(".register-layer input[name=password]").addEventListener("keydown",function() {
		var pwInput = document.querySelector(".register-layer input[name=password]");
		pwInput.classList.remove("required");
	});

	document.querySelector(".register-layer input[name=password]").addEventListener("blur", function() {
		var pwInput = document.querySelector(".register-layer input[name=password]");
		if(pwInput.value == "") pwInput.classList.add("required");
	});
	document.querySelector(".register-layer input[name=passwordConfirm]").addEventListener("keydown", function() {
		var pwInput = document.querySelector(".register-layer input[name=passwordConfirm]");
		pwInput.classList.remove("required");
	});
	document.querySelector(".register-layer input[name=passwordConfirm]").addEventListener("blur", function() {
		var pwInput = document.querySelector(".register-layer input[name=passwordConfirm]");
		if(pwInput.value == "") pwInput.classList.add("required");
	});
	document.querySelector(".register-layer input[name=name]").addEventListener("keydown", function() {
		var pwInput = document.querySelector(".register-layer input[name=name]");
		pwInput.classList.remove("required");
	});
	document.querySelector(".register-layer input[name=name]").addEventListener("blur", function() {
		var pwInput = document.querySelector(".register-layer input[name=name]");
		if(pwInput.value == "") pwInput.classList.add("required");
	});
	document.querySelector("#login-btn").addEventListener("click", function() {
		var idInput = document.querySelector(".login-layer input[name=userId]");
		var pwInput = document.querySelector(".login-layer input[name=password]");
		var errTxt = document.querySelector(".login-layer .login-err");
		if(idInput.value == "") {
			idInput.classList.add("required");
			idInput.focus();
			errTxt.innerHTML = "아이디를 입력해주세요.";
			errTxt.classList.add("show");
			return;
		} else if(pwInput.value == "") {
			pwInput.classList.add("required");
			pwInput.focus();
			errTxt.innerHTML = "비밀번호를 입력해주세요.";
			errTxt.classList.add("show");
			return;
		}
		$(".dim").show();
		$(".dim .loading-layer").show();
		$.ajax({
			url: "/api/auth/login",
			type: 'POST',
			contentType: "application/json",
			async: false,
			data: JSON.stringify({
				"userId": document.querySelector(".login-layer input[name=userId]").value,
				"password": document.querySelector(".login-layer input[name=password]").value
			}),
			success: function(data) {
				document.cookie = 'accessToken=' + data.accessToken + ';path=/;max-age=' + data.accessExpire;
				location.reload();
			},
			error: function(error) {
				var errTxt = document.querySelector(".login-layer .login-err");
				errTxt.innerHTML = "아이디 혹은 비밀번호가 일치하지 않습니다";
				errTxt.classList.add("show");
			}
		});
		$(".dim").hide();
		$(".dim .loading-layer").hide();
	});
	document.querySelector("#register-btn").addEventListener("click", function() {
		var idInput = document.querySelector(".register-layer input[name=userId]");
		var pwInput = document.querySelector(".register-layer input[name=password]");
		var pwConfirmInput = document.querySelector(".register-layer input[name=passwordConfirm]");
		var nameInput = document.querySelector(".register-layer input[name=name]");
		var termChkInput = document.querySelector(".register-layer input[name=termsCheck]");
		var errTxt = document.querySelector(".register-layer .login-err");
		
		var pwReg =  /^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,20}$/;
		
		if(idInput.value == "") {
			idInput.classList.add("required");
			idInput.focus();
			errTxt.innerHTML = "아이디를 입력해주세요.";
			errTxt.classList.add("show");
			return;
		}else if(pwInput.value == "") {
			pwInput.classList.add("required");
			pwInput.focus();
			errTxt.innerHTML = "비밀번호를 입력해주세요.";
			errTxt.classList.add("show");
			return;
		}else if(!pwReg.test(pwInput.value)){
			pwInput.classList.add("required");
			pwInput.focus();
			errTxt.innerHTML = "영문, 숫자, 특수기호, 조합 8~20자리를 사용해야 합니다.";
			errTxt.classList.add("show");
			return;
		}else if(pwConfirmInput.value == "") {
			pwConfirmInput.classList.add("required");
			pwConfirmInput.focus();
			errTxt.innerHTML = "비밀번호를 입력해주세요.";
			errTxt.classList.add("show");
			return;
		} else if(pwInput.value != pwConfirmInput.value) {
			pwConfirmInput.classList.add("required");
			pwConfirmInput.focus();
			errTxt.innerHTML = "비밀번호가 일치하지 않습니다.";
			errTxt.classList.add("show");
			return;
		} else if(nameInput.value == "") {
			nameInput.classList.add("required");
			nameInput.focus();
			errTxt.innerHTML = "이름을 입력해주세요.";
			errTxt.classList.add("show");
			return;
		} else if(!termChkInput.checked) {
			termChkInput.focus();
			errTxt.innerHTML = "개인정보 수집이용에 동의해주세요.";
			errTxt.classList.add("show");
			return;
		}
		$(".dim").show();
		$(".dim .loading-layer").show();
		$.ajax({
			url: "/api/auth/register",
			type: 'POST',
			contentType: "application/json",
			async: false,
			data: JSON.stringify({
				"userId": idInput.value,
				"password": pwInput.value,
				"name": nameInput.value
			}),
			success: function(data) {
				if(data.status == "Y") {
					document.cookie = 'accessToken=' + data.token.accessToken + ';path=/;max-age=' + data.token.accessExpire;
					Swal.fire({
						title: '회원가입 완료!',
						icon: 'success'
					}).then(function() {
						location.reload();
					});
				} else {
					errTxt.innerHTML = data.msg;
					errTxt.classList.add("show");
				}
			},
			error: function(error) {
				errTxt.innerHTML = "오류가 발생하였습니다. 관리자에게 문의해 주세요.";
				errTxt.classList.add("show");
			}
		});
		$(".dim").hide();
		$(".dim .loading-layer").hide();
	});
	</c:if>
	<c:if test="${userInfo ne null}">
		var btn = document.querySelector("#user-box");
		var nav = document.querySelector("#nav-dropdown");
	
		btn.addEventListener('click', () => {
		  if(!btn.classList.contains("is-open")) {
		    btn.classList.add("is-open");
		    nav.classList.add("is-open");
		  } else {
		    btn.classList.remove("is-open");
		    nav.classList.remove("is-open");
		  }
		});
		document.querySelector("#logout-btn").addEventListener("click",function() {
			document.cookie = 'refreshToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
			document.cookie = 'accessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
			location.reload();
		});
		
		document.querySelector("#mypage-btn").addEventListener("click", function(){
			Swal.fire({
				   title: '미완성',
				   text: '빠른 시일내에 완성하겠습니다.',
				   icon: 'warning',
			})
		})
	</c:if>
</script>