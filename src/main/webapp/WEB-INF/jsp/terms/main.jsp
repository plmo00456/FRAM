<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>내주변맛집</title>
    
    <c:import url="/common/files" charEncoding="UTF-8"/>    
    <link href="/css/main/main.css" rel="stylesheet" type="text/css" />
    <link href="/css/main/map.css" rel="stylesheet" type="text/css" />
    <link href="/css/main/m_main.css" rel="stylesheet" type="text/css" />

    <script>
    $(document).ready(function() {
    	var hash = window.location.hash;
    	var mode = hash ? hash : "privacy";
    	window.location.hash = mode;
	    $.ajax({
			url:"/terms/"+mode,
			type:"get",
			datatype:"html",
			success:function(data){
				$(".main .content").html(data);
			}	
		});
    });
    </script>
  </head>
  <body>
  	<div class="wrap">
  		<c:import url="/common/top" charEncoding="UTF-8">
  			<c:param name="currentMenu" value="${currentMenu}"/>
  		</c:import>
  		
  		<div class="main">
  			<div class="container">
  				<nav class="sub-menu">
  					<ul>
  						<li>개인정보 처리방침</li>
  						<li>서비스 이용약관</li>
  					</ul>
  				</nav>
  				<div class="content">
  					
  				</div>
  			</div>
  		</div>
  		
  		<c:import url="/common/fotter" charEncoding="UTF-8">
  			<c:param name="currentMenu" value="${currentMenu}"/>
  		</c:import>

  	</div>
  	<div class="dim">
  		<div class="layer loading-layer">
  			<img src="/image/loading.gif">
  			<span>Loading...</span>
  		</div>
  		<div class="layer image-layer" data-allcnt="0" data-current="0" data-mode="">
  			<div class="image">
  				<img src="" alt="큰 이미지">
  			</div>
  			<div class="btns">
  				<button class="left">
  					<i class="fa-solid fa-chevron-left"></i>
  				</button>
  				<button class="right">
  					<i class="fa-solid fa-chevron-right"></i>
  				</button>
  			</div>
  		</div>
  	</div>
  </body>
</html>