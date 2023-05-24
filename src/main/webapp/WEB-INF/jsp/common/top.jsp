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
							<p class="user-nickname">${userInfo.nickname}</p>
						</c:if>
						<c:if test="${not empty userInfo.nickname}">
							<p class="user-icon">${fn:substring(userInfo.name,0,1)}</p>
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
		document.querySelector("#logout-btn").parentElement.addEventListener("click",function() {
			document.cookie = 'refreshToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
			document.cookie = 'accessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
			location.reload();
		});
		
		document.querySelector("#mypage-btn").parentElement.addEventListener("click", function(){
			var userInfo = getUserInfo();
			var Toast = Swal.mixin({
			    toast: true,
			    position: 'center',
			    showConfirmButton: false,
			    timer: 2000,
			    timerProgressBar: true,
			    didOpen: (toast) => {
				    toast.addEventListener('click', Swal.close)
				}
			});
			Swal.fire({
				  title: '<strong>내정보</strong>',
				  html:
					'<div class="profile-box">'+
					    '<div class="profile-info">' +
							'<div class="item"><span class="title">아이디</span> <input type="text" disabled value="' + isEmpty(userInfo.user.id,'') + '"></div>'+
							'<div class="item"><span class="title">이메일</span> <input type="text" disabled value="' + isEmpty(userInfo.user.email,'') + '"></div>'+
							'<div class="item"><span class="title">연동소셜</span> <input type="text" disabled value="' + provideKr(isEmpty(userInfo.user.provide,'')) + '"></div>'+
							'<div class="item"><span class="title">이름</span> <input type="text" onChange="requiredClass(this)" maxlength="10" name="name" value="' + isEmpty(userInfo.user.name,'') + '" required></div>'+
							'<div class="item"><span class="title">닉네임</span> <input type="text" onChange="requiredClass(this)" maxlength="10" name="nickname" value="' + isEmpty(userInfo.user.nickname,'') + '" required></div>'+
					  	'</div>'+
					  	'<div class="profile-image">'+
					  		'<div class="profile-image-view" onclick="uploadImage(\'profile-image-input\');"><span class="user-profile-name"></span><span class="text">변경</span></div>'+
					  		'<input type="file" accept="image/*" name="profile-image" id="profile-image-input" class="profile-image-input" onchange="setImageBackground(event, \'.profile-box .profile-image-view\'); document.querySelector(\'.profile-box .user-profile-name\').innerHTML = \'\';">'+
				  		'</div>'+	
				  	'</div>'
				  	,
				  didOpen: () => {
					var img = Swal.getPopup().querySelector(".profile-image-view");

				  	if(userInfo.user.profileImage && userInfo.user.profileImage.filename) img.style.background = "url('" + userInfo.user.profileImage.filepath + userInfo.user.profileImage.filename + "') center center / cover";
				  	else{
				  		var span = Swal.getPopup().querySelector(".user-profile-name");
				  		span.classList.add("user-profile-name");
				  		span.innerText = isEmpty(userInfo.user.name,'').substring(0,1);
				  		
				  		img.style.background = "#33691d";
				  		img.style.color = "#fff";
				  		img.style.fontSize = "5rem";
				  	}
				  },
				  showCloseButton: true,
				  showCancelButton: true,
				  confirmButtonColor: '#6c55f7',
				  cancelButtonColor: '#d33',
				  confirmButtonText: '저장',
				  cancelButtonText: '취소',
				  focusConfirm: false,
				  preConfirm: function() {
					  	setTimeout(function(){				                    	
	                    	Swal.showLoading();
	                    },1);
					    var name = Swal.getPopup().querySelector("input[name=name]");
				        var nickname = Swal.getPopup().querySelector("input[name=nickname]");
				        var profileImage = Swal.getPopup().querySelector("#profile-image-input");
				        
				        if (name.value.trim() === "") {
				            name.classList.add("required");
				            name.focus();
				            Swal.showValidationMessage("이름을 입력해주세요.");
				            swal.hideLoading();
				            return false;
				        }
				        
				        if (nickname.value.trim() === "") {
				            nickname.classList.add("required");
				            nickname.focus();
				            Swal.showValidationMessage("닉네임을 입력해주세요.");
				            return false;
				        }
				        
				        var form = {
				            name: name,
				            nickname: nickname,
				            "profile-image": profileImage
				        };
				        var formData = createFormDataFromObject(form);
				        $.ajax({
				            url: "/api/auth/update",
				            type: "POST",
				            processData: false,
				            contentType: false,
				            cache: false,
				            async: false,
				            data: formData,
				            success: function(data) {
				                if (data.status === "Y") {
				                    return true;
				                } else {
				                    Swal.showValidationMessage(data.msg);
				                    swal.hideLoading();
				                }
				            },
				            error: function(error) {
				                Swal.showValidationMessage(error.responseJSON && error.responseJSON.msg ? error.responseJSON.msg : "오류가 발생하였습니다.<br>관리자에게 문의해 주세요.");
				                swal.hideLoading();
				            }
				        });
					}
				}).then(function(result) {
					if (result.isConfirmed) {
						Toast.fire({
						    icon: 'success',
						    title: "변경되었습니다.",
						    didClose: function(){						    	
					        	window.location.reload();
						    }
						});
					}
				});
		})
	</c:if>
</script>
<style>
	.profile-box{
		display: flex;
	    justify-content: space-around;
	    width: 100%;
	}
	.profile-box .profile-info{
	}
	.profile-box .profile-info .item{
		display: flex;
    	flex-direction: column;
    	align-items: flex-start;
   	    margin-bottom: 10px;
	}
	.profile-box .profile-info .item .title{
	    font-size: .8rem;
    	margin-bottom: 3px;
	}
	.profile-box .profile-info .item input{
		border-radius: 5px;
	    border: 1px solid #cdcdcd;
	    font-size: 1rem;
        padding: 5px;
        color: #5c5c5c;
	}
	.profile-box .profile-info .item input.required{
	    border: 1px solid red;
	}
	.profile-box .profile-info .item input.required:focus{
	    outline: none;
	}
	.profile-box .profile-image{
	    display: flex;
	    justify-content: flex-start;
	    align-items: center;
	}
	.profile-box .profile-image .profile-image-view{
	    position: relative;
	    border: 1px solid #979797;
	    width: 140px;
	    height: 140px;
	    border-radius: 50%;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    overflow: hidden;
	    cursor: pointer;
        background-size: cover !important;
	}
	
	.profile-box .profile-image .profile-image-view:before {
	    content: '';
	    position: absolute;
	    bottom: -100px;
	    width: 140px;
	    height: 140px;
	    border-radius: 0;
	    background-color: rgba(0, 0, 0, 0.5);
	    opacity: 0;
	    transition: opacity .2s linear;
	  }
	 
	  .profile-box .profile-image .profile-image-view:hover:before {
	    opacity: 1;
	  }
	 
	  .profile-box .profile-image .profile-image-view .text {
	    color: white;
	    font-size: 1rem;
	    text-align: center;
	    opacity: 0;
	    transition: opacity .2s linear;
        margin-top: 85px;
        z-index: 1;
        font-weight: 300;
        position: absolute;
	  }
	 
	  .profile-box .profile-image .profile-image-view:hover .text {
	    opacity: 1;
	  }
	
	.profile-box .profile-image .profile-image-input{
		display: none;
	}
</style>