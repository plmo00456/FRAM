<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script src="https://kit.fontawesome.com/790b1811b6.js" crossorigin="anonymous"></script>
    
    <link href="/css/common/basic.css" rel="stylesheet" type="text/css" />
    <link href="/css/main/main.css" rel="stylesheet" type="text/css" />
    <link href="/css/main/map.css" rel="stylesheet" type="text/css" />
    
    <script src="/js/util/util.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services,clusterer"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/plugin/star-rating/jstars.js"></script>

    <script src="/js/main/map.js"></script>

    <script>
      $(document).ready(function() {
    	document.querySelector(".dim").addEventListener("click", function(e){
    		if (e.target !== e.currentTarget) return;
    		$(this).fadeOut();
    		var layers = document.querySelectorAll(".dim .layer");
    		layers.forEach(function(layer){
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
    		var current = parseInt(imgLayer.dataset.current);
	    	if(imgLayer.style.display != "none" && imgLayer.style.display != ""){
	    		var leftBtn = document.querySelector(".dim .image-layer .btns .left");
				var rightBtn = document.querySelector(".dim .image-layer .btns .right");
				if(e.key == "ArrowLeft" && leftBtn.style.display != "none" && leftBtn.style.display != "")
					prevNextImage(current - 1);
				else if(e.key == "ArrowRight" && rightBtn.style.display != "none" && rightBtn.style.display != "")
					prevNextImage(current + 1);
			}
    	});
    	
    	
        // 맵 표시
        getUserLocation();
      });
    </script>
  </head>
  <body>
  	<div class="wrap">
	  	<div class="container">
	  		<div class="top">
	  		</div>
	  		<div class="main">
	  			<div id="map" class="map"></div>
	  		</div>
	  		<div class="footer">
	  		</div>
	  	</div>
  	</div>
  	<div class="dim">
  		<div class="layer image-layer" data-allcnt="0" data-current="0">
  			<div class="title"></div>
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
	
	<style>
		.dim{
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
			cursor:pointer;
			-webkit-user-select: none;
			-moz-user-select: none;
			-ms-user-select: none;
			user-select: none;
		}
		
		.dim .image-layer{
			width: 70%;
			height: 70%;
			display: none;
			justify-content: center;
			align-content: center;
			flex-direction: column;
			padding: 50px;
			background: #fff;
			border-radius: 13px;
			cursor: auto;
			position: relative;
			box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px
		rgba(0, 0, 0, 0.22);
		}
		
		.dim .image-layer .image{
			width: 100%;
			height: 93%;
			display: flex;
			justify-content: center;
		}
		
		.dim .image-layer .image img{
			width: auto;
			max-width: 100%;
		}
		
		.dim .image-layer .title{
			width: 100%;
			height: 7%;
			display: flex;
			justify-content: center;
			font-size: 1.5rem;
			align-content: center;
			font-weight: 700;
		}
		
		.dim .image-layer .btns button{
			position: absolute;
			top: 0;
			height: 100%;
			min-width: 140px;
			background: transparent;
			border: none;
			cursor: pointer;
			color: #8c8787;
			font-size: 2.5rem;
			display: none;
		}
		
		.dim .image-layer .btns .left{
			text-align: left;
			left: 0;
			padding-left: 40px;
		}
		
		.dim .image-layer .btns .left:hover{
			color: #696969;
			background: linear-gradient(to right, rgba(60, 60, 60, 0.2),  transparent);
		}
		
		.dim .image-layer .btns .right{
			right: 0;
			text-align: right;
			padding-right: 40px;
		}
		
		.dim .image-layer .btns .right:hover{
			color: #696969;
			background: linear-gradient(-90deg, rgba(60, 60, 60, 0.2),  transparent);
		}
		
		
	</style>
  </body>
</html>