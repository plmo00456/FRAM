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
					<p class="user-icon">${fn:substring(userInfo.name,0,1)}</p>
					<p class="user-nickname">${userInfo.nickname}</p>
					<div class="logout-btn" id="logout-btn"><i class="fa-solid fa-right-from-bracket"></i></div>
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
	    document.querySelector(".login-layer-btn").addEventListener("click", function(){
			$(".user-dim").css("display", "flex").hide().fadeIn("fast", function(){
				$(".user-dim .login-layer").css("display", "flex").hide().fadeIn();
				document.querySelector(".login-layer input[name=userId]").focus();
			});
		});
		document.querySelector(".register-layer-btn").addEventListener("click", function(){
			
		});

		document.querySelector(".login-layer input[name=userId]").addEventListener("keydown", function(){
			var idInput = document.querySelector(".login-layer input[name=userId]");
			idInput.classList.remove("required");
		});
		
		document.querySelector(".login-layer input[name=userId]").addEventListener("blur", function(){
			var idInput = document.querySelector(".login-layer input[name=userId]");
			if(idInput.value == "") idInput.classList.add("required");
		});
		
		document.querySelector(".login-layer input[name=password]").addEventListener("keydown", function(){
			var pwInput = document.querySelector(".login-layer input[name=password]");
			pwInput.classList.remove("required");
		});
		
		document.querySelector(".login-layer input[name=password]").addEventListener("blur", function(){
			var pwInput = document.querySelector(".login-layer input[name=password]");
			if(pwInput.value == "") pwInput.classList.add("required");
		});
		
		document.querySelector("#login-btn").addEventListener("click", function(){
			var idInput = document.querySelector(".login-layer input[name=userId]");
			var pwInput = document.querySelector(".login-layer input[name=password]");
			var errTxt = document.querySelector(".login-layer .login-err");
			if(idInput.value == ""){
				idInput.classList.add("required");
				idInput.focus();
				errTxt.innerHTML = "아이디를 입력해주세요.";
				errTxt.classList.add("show");
				return;
			}else if(pwInput.value == ""){
				pwInput.classList.add("required");
				pwInput.focus();
				errTxt.innerHTML = "비밀번호를 입력해주세요.";
				errTxt.classList.add("show");
				return;
			}
			$.ajax({
				url : "/api/auth/login",
				type: 'POST',
				contentType: "application/json",
			    data: JSON.stringify({
			        "userId": document.querySelector("input[name=userId]").value,
			        "password": document.querySelector("input[name=password]").value
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
		});
	</c:if>
	<c:if test="${userInfo ne null}">
		document.querySelector("#logout-btn").addEventListener("click", function(){
			document.cookie = 'refreshToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
			document.cookie = 'accessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
			location.reload();
		});
	</c:if>
</script>

<style>
	.wrap .top .container{
		width: 1000px;
	    height: 100%;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	}
	
	.wrap .top .logo{
	    width: 110px;
   		height: 50%;
	}
	
	.wrap .top .links {
	    display: flex;
	    width: 80%;
	    justify-content: space-between;
	    align-items: center;
	}
	
	.wrap .top .links .menu{
		font-size: 1.2rem;
		font-weight: 600;
	}
	
	.wrap .top .links .menu a:hover{
		color: #65a6f6;
	}
	
	.wrap .top .links .menu a.current{
		color: #0069ec;
	    border-bottom: 4px solid#0069ec;
	    padding-bottom: 15px;
	}
	
	
	.wrap .top .links .menu a{
		margin-right: 10px;
	}
	
	.wrap .top .links .login{
	    display: flex;
        font-size: 1.3rem;
        justify-content: center;
        align-items: center;
	}
	
	.wrap .top .links .login .user-icon{
		width: 20px;
		height: 20px;
		padding: 5px;
		border-radius: 20px;
		color: #fff;
		background: #33691d;
		display: flex;
		justify-content: center;
		align-items: center;
		font-size: 1rem;
	}
	
	.wrap .top .links .login .user-nickname{
		height: fit-content;
		margin-left: 5px;
		font-size: 1.2rem;
	}
	
	.wrap .top .links .login > div{
		margin-right: 10px;
	    width: 2.5rem;
	    height: 2.5rem;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    border-radius:5px;
	    cursor: pointer;
	}
	
	.wrap .top .links .login > div:hover{
		background: #e5e4e4;
	}
	
	
</style>