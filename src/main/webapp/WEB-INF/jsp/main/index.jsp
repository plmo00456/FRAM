<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내주변맛집</title>
    
    <c:import url="/common/files" charEncoding="UTF-8"/>

	<link href="/plugin/rateyo/jquery.rateyo.min.css" rel="stylesheet" type="text/css" />    
    <link href="/css/main/main.css" rel="stylesheet" type="text/css" />
    <link href="/css/main/map.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services,clusterer"></script>
    <script src="/plugin/star-rating/jstars.js"></script>
    <script src="/plugin/rateyo/jquery.rateyo.min.js"></script>

    <script src="/js/main/map.js"></script>

    <script>
      $(document).ready(function() {
    	if (window.location.hash == '#relogin') {
    		var loginLayerBtn = document.querySelector(".login-layer-btn");
    		loginLayerBtn.click();
    		window.location.hash = "";
  		}
    	  
   	  	document.addEventListener("click", function() {
   	 		removeAllContextMenu();
   	  	});
    	document.querySelector(".dim").addEventListener("click", function(e){
    		if (e.target !== e.currentTarget) return;
    		$(this).fadeOut();
    		var layers = document.querySelectorAll(".dim .layer");
    		layers.forEach(function(layer){
    			if(layer.classList.contains("image-layer")){
    				layer.style.transition = "unset";
    				layer.style.WebkitTransition = "unset";
    				layer.style.MozTransition = "unset";
    				layer.style.MsTransition = "unset";
    				layer.style.OTransition = "unset";
    			}
    			layer.style.display = "none";
    		});
    	});
    	
    	document.querySelector(".dim .image-layer .btns .left").addEventListener("click", function (e){
    		var imgLayer = document.querySelector(".dim .image-layer");
    		var current = parseInt(imgLayer.dataset.current);
    				prevNextImage(current - 1);
    	});
    	
    	document.querySelector(".dim .image-layer .btns .right").addEventListener("click", function (e){
    		var imgLayer = document.querySelector(".dim .image-layer");
    		var current = parseInt(imgLayer.dataset.current);
    				prevNextImage(current + 1);
    	});
    	
    	document.addEventListener("keydown", function (e){
    		var imgLayer = document.querySelector(".dim .image-layer");
    		var loginLayer = document.querySelector(".user-dim .login-layer");
    		var current = parseInt(imgLayer.dataset.current);
	    	if(imgLayer.style.display != "none" && imgLayer.style.display != ""){
	    		var leftBtn = document.querySelector(".dim .image-layer .btns .left");
				var rightBtn = document.querySelector(".dim .image-layer .btns .right");
				if(e.key == "ArrowLeft" && leftBtn.style.display != "none" && leftBtn.style.display != "")
					prevNextImage(current - 1);
				else if(e.key == "ArrowRight" && rightBtn.style.display != "none" && rightBtn.style.display != "")
					prevNextImage(current + 1);
				else if(e.key == "Escape")
					document.querySelector(".dim").click();
			}if(loginLayer.style.display != "none" && loginLayer.style.display != ""){
				if(e.key == "Enter")
					document.querySelector("#login-btn").click();
			}else{
				if(e.key == "Escape"){
					document.querySelector(".custom-overlay .close-btn").click();
				}
			}
    	});
    	
    	document.querySelector(".user-dim").addEventListener("click", function(e){
    		if (e.target !== e.currentTarget) return;
    		$(this).fadeOut();
    		var layers = document.querySelectorAll(".user-dim .layer");
    		layers.forEach(function(layer){
    			layer.style.display = "none";
    		});
    	});
    	
    	
        // 맵 표시
        getUserLocation();
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
  				<div id="map" class="map">
  					<div id="relocate" onclick="relocate();">
	  					<i class="fa-solid fa-repeat"></i>&nbsp;현 위치에서 검색
	  				</div>
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
  		<div class="layer image-layer" data-allcnt="0" data-current="0">
  			<div class="image">
  				<img src="http://postfiles15.naver.net/MjAyMDA2MjVfMTEy/MDAxNTkzMDE2NjY0Njk4.QvjPsbJDWAFxIJL2HY4vKE-L1JJbdh1whvfgjrM7HRUg.xxRloYWCYQ4nUr9mr0TiZSabknlGbciPH-7JJqHphZAg.JPEG.birth1012/IMG_8774.jpg?type=w966" alt="큰 이미지">
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