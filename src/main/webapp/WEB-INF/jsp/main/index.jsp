<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script src="https://kit.fontawesome.com/790b1811b6.js" crossorigin="anonymous"></script>
    
    <link href="/css/main/main.css" rel="stylesheet" type="text/css" />
    <link href="/css/main/map.css" rel="stylesheet" type="text/css" />
    
    <script src="/js/util/util.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services,clusterer"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/plugin/star-rating/jstars.js"></script>

    <script src="/js/main/map.js"></script>

    <script>
      $(document).ready(function() {
        // 맵 표시
        getUserLocation();
      });
    </script>
  </head>
  <body>

    <div id="map" class="map"></div>

    
<!--     <div class="custom-overlay dev">
    	<div class="top">
    		<div class = "title">
    			<span class="main-title">대성콩물</span>
    			<span class="sub-title">국수</span>
    		</div>
    		<div class = "close-btn"><i class="fa-solid fa-xmark"></i></div>
    	</div>
    	<div class="content">
			<div class="image-list">
				<div class="image-container first">
					<div class="image">
						<img src = "http://t1.daumcdn.net/place/1A4312168AFD4A53B722C969F79D1F3A" alt = "thumbnail">
					</div>
				</div>
				<div class="image-container second">
					<div class="row">
						<div class="image">
							<img src = "http://t1.daumcdn.net/local/kakaomapPhoto/review/7f948f8497d6c33c630d5eeda453b2c7fb31cd80?original" alt = "thumbnail">
						</div>
						<div class="image">
							<img src = "http://t1.daumcdn.net/local/kakaomapPhoto/review/18703b001147576736534b7569dbd331e2df8156?original" alt = "thumbnail">
						</div>
					</div>
					<div class="row">
						<div class="image">
							<img src = "http://t1.daumcdn.net/local/kakaomapPhoto/review/bedb9161ae542db78b753341012c089b702b3a46?original" alt = "thumbnail">
						</div>
						<div class="image">
							<img src = "http://t1.daumcdn.net/local/kakaomapPhoto/review/d71debb5f433e19c6f5d351a2de139041b45ebf3?original" alt = "thumbnail">
						</div>
					</div>
				</div>
			</div>
			<div class="addr-container">
				<div class="icon">
					<i class="fa-solid fa-location-dot"></i>
				</div>
				<div class="cont">광주 북구 제봉로 272 (우)61236</div>
			</div>
			<div class="opentime-container">
				<div class="icon">
					<i class="fa-solid fa-clock"></i>
				</div>
				<div class="cont">
					<div class="status deadline">금일영업마감</div>
					<div class="opentime">매일 09:00 ~ 20:00</div>
				</div>
			</div>
			<div class="tel-container">
				<div class="icon">
					<i class="fa-solid fa-phone"></i>
				</div>
				<div class="cont">062-1111-2222</div>
			</div>
			<div class="comment-title">
				<i class="fa-solid fa-face-smile"></i>
				<div class="rate-container">
	    			<span id="rate-value">0.0</span>
					<div id="rate" data-value="0" data-total-stars="5" data-color="#ffb553" data-empty-color="lightgray" data-size=".9rem"> </div>
					<span id="rate-cnt">0건</span>
				</div>
			</div>
			<div class="comment-container">
			
				<div class="list">
					<div class="image">
						<img src = "http://t1.daumcdn.net/local/kakaomapPhoto/review/d71debb5f433e19c6f5d351a2de139041b45ebf3?original" alt = "thumbnail">
					</div>
					<div class="cont-container">
						<div class="top">
							<div class="nickname">
								<span class="rating">★1.1</span>
								<b>티이모</b>
							</div>
							<div class="dt">10초 전</div>
						</div>
						<div class="cont">
						    ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㄴㄴㄴㄴㄴㄴㄴㄴㄴ
						    <div class="fade-out">
						        <button class="more-btn">더보기...</button>
						    </div>
						</div>
					</div>
				</div>
				
				<div class="list">
					<div class="image">
						<img src = "http://t1.daumcdn.net/local/kakaomapPhoto/review/d71debb5f433e19c6f5d351a2de139041b45ebf3?original" alt = "thumbnail">
					</div>
					<div class="cont-container">
						<div class="top">
							<div class="nickname">
								<span class="rating">★1.1</span>
								<b>티이모</b>
							</div>
							<div class="dt">10초 전</div>
						</div>
						<div class="cont">
						    ㅁ
						    <div class="fade-out">
						        <button class="more-btn">더보기...</button>
						    </div>
						</div>
					</div>
				</div>
				
			</div>
    	</div>
	</div> -->
	
	
	
	<style>
		.custom-overlay.dev{
			position: absolute; left: 1030px; top: 220px;
		}
		
		.custom-overlay > .top{
			display: flex;
		    justify-content: space-between;
		    width: 100%;
		    margin-bottom: 5px;
		}
		
		.custom-overlay .top .title .main-title{
			font-size: 1.2rem;
		}
		
		.custom-overlay .top .title .sub-title{
		    font-size: .8rem;
    		color: #adadad;
		}
		
		.custom-overlay .top .close-btn{
			cursor: pointer
		}
		
		.custom-overlay .content{
			font-size: .9rem;
		}
		
		.custom-overlay .content .image-list{
		    display: flex;
			width: 100%;
			height: 130px;
		}
		
		.custom-overlay .content .image-list .image-container{
			display: flex;
		    width: 50%;
		    height: 100%;
	    }
	    
	    .custom-overlay .content .image-list .image-container.second{
    		flex-direction: column;
	    }
	    
	    .custom-overlay .content .image-list .image-container.second .row{
	    	display:flex;
    	    height: 50%;
    		width: 100%;
	    }
	    
	    .custom-overlay .content .image-list .image-container .image{
	        width: 100%;
    		height: 100%;
    		overflow: hidden;
	    }
	    
	    .custom-overlay .content .image-list .image-container .image img{
	    	width: 100%;
    		height: 100%;
    		cursor: pointer;
    		transition: all 0.2s linear;
	    }
	    
	    .custom-overlay .content .image-list .image-container .image img:hover{
	    	filter: brightness(80%);
	    	transform: scale(1.1);
	    }
	    
	    .custom-overlay .content .addr-container{
	    	display: flex;
	    	width: 100%;
	    	margin-top: 10px;
	    }
	    
	    .custom-overlay .content .addr-container .icon{
	    	width: 20px;
	    }
	    
	    .custom-overlay .content .opentime-container{
	    	display: flex;
	    	width: 100%;
	    	margin-top: 5px;
	    }
	    
	    .custom-overlay .content .opentime-container .icon{
	    	width: 20px;
	    }
	    
	    .custom-overlay .content .opentime-container .cont .status.yet{
    	    color: #a0a0a0;
	    }
	    .custom-overlay .content .opentime-container .cont .status.operating{
	    	color: #37f845
	    }
	    .custom-overlay .content .opentime-container .cont .status.deadline{
    	    color: #ffb553;
	    }
	    
	    .custom-overlay .content .tel-container{
	    	display: flex;
	    	width: 100%;
	    	margin-top: 5px;
	    }
	    
	    .custom-overlay .content .tel-container .icon{
	    	width: 20px;
	    }
	    
	    .custom-overlay .comment-title{
	    	margin: 5px 0;
	    	display: flex;
	    	align-items: center;
	    }
	    
	    .custom-overlay .comment-title .rate-container{
	    	display: flex;
	    	margin-left: 5px;
	    	width: 115px;
			justify-content: space-between;
	    }
	    
	    .custom-overlay .comment-container{
    	    display: flex;
		    width: 100%;
		    flex-direction: column;
		    max-height: 150px;
		    overflow-y: auto;
		    margin-top: 5px;
	    }
	    
	    .custom-overlay .comment-container::-webkit-scrollbar {
		  width: 5px; /* 스크롤바 너비 */
		  height: 5px; /* 스크롤바 높이 (필요한 경우 설정) */
		  background: transparent; /* 스크롤바 배경색 투명 */
		}
		.custom-overlay .comment-container::-webkit-scrollbar-thumb {
		  background-color: #888; /* 스크롤바 썸네일 색상 */
		  border-radius: 2px; /* 스크롤바 썸네일 모서리 둥글게 처리 */
		}

		.custom-overlay .comment-container::-webkit-scrollbar-thumb:hover {
		  background-color: #555; /* 스크롤바 썸네일 호버 색상 */
		}
		
		.custom-overlay .comment-container .list{
		    display: flex;
		    width: 100%;
		    border-bottom: 1px solid #a5a5a5;
	    }
		
		.custom-overlay .comment-container .list:first-child{
			padding-bottom: 5px;
		}
	    
	    .custom-overlay .comment-container .list:not(:first-child){
    	    padding: 5px 0;
	    }
	    
	    .custom-overlay .comment-container .list .image{
	    	width: 20%;
		    height: 50px;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    padding: 1%;
	    }
	    
	    .custom-overlay .comment-container .list .image img{
		    width: 100%;
	    	height: 100%;
	    	cursor: pointer;
	    }
	    
	    .custom-overlay .comment-container .list .cont-container{
	    	width:75%;
	    	overflow: hidden;
	    }
	    
	    .custom-overlay .comment-container .list .cont-container .top{
	    	display: flex;
	    	justify-content: space-between;
	    }
	    
	    .custom-overlay .comment-container .list .cont-container .top .nickname{
	    	margin-left: 5px;
	    }
	    
	    .custom-overlay .comment-container .list .cont-container .top .rating{
	    	color: #ffb553;
	    	font-weight: 600;
	    }
	    
	    .custom-overlay .comment-container .list .cont-container .cont {
		    margin-left: 5px;
		    position: relative;
		    overflow: hidden;
		    height: 35px;
		}
		
		.custom-overlay .comment-container .list .cont-container .cont.more {
			overflow: unset;
			height: max-content;
		}
		
		.custom-overlay .comment-container .list .cont-container .cont .fade-out{
			display: none;
		}
		
		.custom-overlay .comment-container .list .cont-container .cont .fade-out.show {
		    position: absolute;
			right: 0;
			bottom: 0;
			width: 31%;
			height: .8rem;
			display: flex;
			justify-content: flex-end;
			align-items: center;
			background-image: linear-gradient(to left,#2f334a 75%, rgba(255, 255, 255, 0));
			padding-bottom: 3px;
		}
		
		.custom-overlay .comment-container .list .cont-container .cont .fade-out .more-btn {
		    background: #2f334a;
			color: #fff;
			border: none;
			font-weight: bold;
			padding: 0;
			cursor: pointer;
		}
	    
	</style>
	
  </body>
</html>