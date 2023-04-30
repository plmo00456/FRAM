<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<div class="user-dim">
    <div class="login-layer layer">
        <div class="logo">
            <img src="/image/logo.png" alt="로고">
        </div>
        <div class="input-box">
            <input type="text" name="id" maxlength="20" placeholder="아이디">
            <input type="password" name="password" maxlength="50" placeholder="비밀번호">
            <input type="button" class="login-btn" value="로그인">
        </div>
        <div class="find-pass">
            <a href="#">비밀번호 재설정</a>
            <a href="#">회원가입</a>
        </div>
        <div class="sns-login">
            <div class="text">SNS로 간편 로그인 / 회원가입</div>
            <div class="sns-btns">
                <button>
                    <img src="/image/auth/naver_btn.png" alt="네이버 로그인">
                </button>
                <button>
                    <img src="/image/auth/kakao_btn.png" alt="카카오 로그인">
                </button>
                <button class="google">
                    <img src="/image/auth/google_btn.png" alt="구글 로그인">
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    .user-dim {
        position: absolute;
        width: 100%;
        height: 100%;
        left: 0;
        top: 0;
        z-index: 9999;
        display: none;
        justify-content: center;
        align-items: center;
        background: rgba(0, 0, 0, 0.58);
        cursor: pointer;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
    }

    .user-dim .login-layer{
        width: 350px;
        background: #fff;
        border-radius: 10px;
        height: 550px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-content: center;
        padding: 40px 50px;
        left: 50%;
        top: 50%;
        position: absolute;
        transform: translate(-50%, -50%);
        display: none;
        cursor: auto;
        box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px
		rgba(0, 0, 0, 0.22);
    }

    .user-dim .login-layer > div{
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
    }

    .user-dim .login-layer .logo img{
        width: 150px;
    }

    .user-dim .login-layer .input-box{
        display: flex;
        justify-content: start;
        flex-direction: column;
        margin-bottom: 20px;
    }

    .user-dim .login-layer .input-box input:first-child{
        width: auto;
        height: 40px;
        border: 1px solid #c7c7c7;
        border-radius: 5px 5px 0 0;
        padding: 0 0 0 13px;
    }

    .user-dim .login-layer .input-box input:not(first-child){
        width: auto;
        height: 40px;
        border-left: 1px solid #c7c7c7;
        border-right: 1px solid #c7c7c7;
        border-bottom: 1px solid #c7c7c7;
        border-top: none;
        border-radius: 0 0 5px 5px;
        padding: 0 0 0 13px;
    }

    .user-dim .login-layer .input-box input.required{
        border: 1px solid red;
    }

    .user-dim .login-layer .input-box input:first-child:focus{
        outline: none;
        border: 1px solid #7c7c7c;
        border-radius: 5px 5px 0 0;
    }

    .user-dim .login-layer .input-box input:not(first-child):focus{
        outline: none;
        border: 1px solid #7c7c7c;
        border-radius: 0 0 5px 5px;
    }

    .user-dim .login-layer .input-box .login-btn{
        margin-top: 15px;
        border-radius: 5px;
        background: #6c55f7;
        cursor: pointer;
        color: #fff;
        font-size: 1.2rem;
        font-weight: 700;
        height: 45px;
    }

    .user-dim .login-layer .input-box .login-btn:hover{
        background: #5e43fe;
    }

    .user-dim .login-layer .sns-login{
        flex-direction: column;
        justify-content: center;
        align-content: center;
    }

    .user-dim .login-layer .sns-login .text{
        display: flex;
        justify-content: center;
        margin-bottom: 10px;
    }

    .user-dim .login-layer .find-pass{
        margin-bottom: 50px;
        justify-content: space-evenly;
    }

    .user-dim .login-layer .sns-login .sns-btns{
        display: flex;
        justify-content: center;
        align-content: center;
    }

    .user-dim .login-layer .sns-login .sns-btns button{
        width: 60px;
        height: 50px;
        background-color: transparent;
        border: none;
        cursor: pointer;
        margin-right: 6px;
    }

    .user-dim .login-layer .sns-login .sns-btns button.google{
        border: 1px solid #dedede;
        border-radius: 100px;
        width: 50px;
        height: 50px;
        margin-left: 5px;
        line-height: 65px;
        margin-right: 0;
    }

    .user-dim .login-layer .sns-login .sns-btns button.google img{
        width: 90%;
        height: 70%;
    }


</style>