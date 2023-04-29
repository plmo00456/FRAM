<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
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
				<c:if test="${sessionScope.userid eq null}">
					<div><i class="fa-solid fa-right-to-bracket"></i></div>
					<div><i class="fa-solid fa-user-plus"></i></div>
				</c:if>
				<c:if test="${sessionScope.userid ne null}">
					<div><i class="fa-solid fa-right-from-bracket"></i>로그아웃</div>
				</c:if>
			</div>
		</div>
	</div>
</div>

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