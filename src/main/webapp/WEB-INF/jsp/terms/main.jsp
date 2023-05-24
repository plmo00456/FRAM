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
	    	getTerms();
		    document.querySelectorAll(".container .sub-menu li a").forEach(function(ele){
		    	ele.addEventListener("click", function(){
		    		window.location.hash = ele.getAttribute("href");
		    		getTerms();
		    	});
		    });
	    });
	    
	    function getTerms(){
	    	var hash = window.location.hash;
	    	var mode = hash ? hash.replace("#", "") : "privacy";
	    	window.location.hash = mode;
		    $.ajax({
				url:"/terms/"+ mode,
				type:"get",
				datatype:"html",
				success:function(data){
					$(".main .content").html(data);
				}
			});
		    document.querySelectorAll(".container .sub-menu li").forEach(function(ele){
		    	if(ele.dataset.terms == mode){
		    		if(!ele.classList.contains("current"))
		    			ele.classList.add("current");
		    	}else{
		    		ele.classList.remove("current");
		    	}
		    });
	    }
    </script>
    <style>
    	.wrap>.main {
		    display: flex;
		    width: 100%;
		    justify-content: center;
		    height: auto;
		}
		.container .content pre{
		    white-space: break-spaces;
    		overflow-wrap: break-word;
		}
		
		.container .sub-menu{
		    margin: 70px 0 30px 0;
		    border-bottom: 1px solid #b6b6b6;
		    font-size: 1.4rem;
		}
		
		.container .sub-menu ul {
			display: flex;
		}
		
		.container .sub-menu ul li{
			margin-right: 30px;
			cursor: pointer;
		}
		
		.container .sub-menu ul li.current {
		    border-bottom: 2px solid #6c55f7;
		    padding-bottom: 35px;
		    color: #6c55f7;
		}
    </style>
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
  						<li data-terms="privacy"><a href="#privacy">개인정보 처리방침</a></li>
  						<li data-terms="service"><a href="#service">서비스 이용약관</a></li>
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