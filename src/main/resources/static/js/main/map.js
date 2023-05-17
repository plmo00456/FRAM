/**
 * [필요]
 * rating.js
 * rating.css
 */


var latitude = 37.566826;
var longitude = 126.9786567;
var mapInitChk = false; // 맵 초기화 여부
var map; // map
var ps; // map.ps 라이브러리
var userMarker; // 사용자 현재 위치
var locYn = false // 사용자 위치 권한 허용 여부    true:허용  false:거부,실패
var clusterer; // 클러스터
var currentOverlay = new Map(); // 현재 열려 있는 오버레이
var currentHoverOverlay = new Map(); // 현재 열려 있는 마우스오버 오버레이
var markers = [];   // 마커
//var keywords = ['식당', '카페', '맛집', '음식', '요리'];
var keywords = ['식당', '카페', '맛집', '음식', '요리', '레스토랑', '뷔페', '바', '퍼브', '이탈리아 음식', '한식', '중식', '일식', '양식', '빵집', '파스타', '피자', '스시', '라멘', '순두부', '김밥', '떡볶이', '치킨', '햄버거', '도넛', '아이스크림', '디저트 카페', '마라탕', '초밥', '피자'];

var infowindow = new kakao.maps.InfoWindow({
	zIndex: 1
});
var mapContainer;
var mapOption = {
		center: new kakao.maps.LatLng(latitude, longitude),
		level: 4
	};

function getUserLocation() {
	if (!navigator.geolocation) {
		errorLoc();
	} else {
		navigator.geolocation.watchPosition(successLoc, errorLoc);
	}
}

function successLoc({
	coords,
	timestamp
}) {
	locYn = true;
	latitude = coords.latitude;
	longitude = coords.longitude;
	if (!mapInitChk) mapInit();
}

function errorLoc(error) {
	if (!mapInitChk) mapInit();
}

function mapInit() {
	$(".dim").show();
	$(".dim .loading-layer").show();
	
	try{
		mapInitChk = true;
		mapContainer = document.querySelector("#map");
		map = new kakao.maps.Map(mapContainer, mapOption);
		ps = new kakao.maps.services.Places();
		
		for (var i = 0; i < keywords.length; i++) {
		    ps.keywordSearch(keywords[i], placesSearchCB, {
		        x: longitude,
		        y: latitude
		    });
		}
		map.setMinLevel(2);
		map.setMaxLevel(10);
		map.setCenter(new kakao.maps.LatLng(latitude, longitude));
		map.setLevel(4);
		clusterer = new kakao.maps.MarkerClusterer({
			map: map,
			averageCenter: true,
			minLevel: 4,
			minClusterSize: 2,
			calculator: [5, 10, 20, 50],
		    styles: [{
				display: 'flex',
				justifyContent: 'center',
    			alignItems: 'center',
		        width: '40px', height: '40px',
		        background: '#0069ecd1',
		        borderRadius: '50%',
		        boxShadow: '0 0 8px rgba(0, 0, 0, 0.4)',
		        color: '#ffffff',
		        textAlign: 'center',
		        fontWeight: 'bold',
		    }]
		});
		if (locYn) {
			var userMarkerPosition = new kakao.maps.LatLng(latitude, longitude);
			userMarker = new kakao.maps.Marker({
				position: userMarkerPosition
			});
			userMarker.setMap(map);
		}
		$('#rate').jstars();
	}catch{
		
	}finally{
		$(".dim").hide();
		$(".dim .loading-layer").hide();
	}
}

function placesSearchCB(data, status, pagination) {
	if (status === kakao.maps.services.Status.OK) {
		var bounds = map.getBounds();
		var tolerance = 1; // 허용 오차 거리 (미터 단위)
		
		for (var i = 0; i < data.length; i++) {
            var isDuplicate = false;
            var latlng = new kakao.maps.LatLng(data[i].y, data[i].x);
            for (var j = 0; j < markers.length; j++) {
                if (isNearbyPos(markers[j].getPosition(), latlng, tolerance)) {
                    isDuplicate = true;
                    break;
                }
            }
            if (!isDuplicate && bounds.contain(latlng)) {
                var marker = createMarker(data[i]);
                markers.push(marker);
                clusterer.addMarker(marker);
            }
        }
		
		// 지도를 드래그 하면 위치 재 검색 div 출력
		kakao.maps.event.addListener(map, 'dragend', function () {
			var relocate = document.querySelector("#relocate");
			relocate.style.display = "flex";
			removeAllHoverOverlays();
		});
		
		// 지도 줌이벤트 시 마우스 오버 효과 삭제
		kakao.maps.event.addListener(map, 'zoom_changed', function() {
		    removeAllHoverOverlays();
		});
	}
}

function toRad(value) {
    return (value * Math.PI) / 180;
}

function haversineDistance(pos1, pos2) {
    var R = 6371; // 지구의 평균 반지름 (km)
    var dLat = toRad(pos2.getLat() - pos1.getLat());
    var dLng = toRad(pos2.getLng() - pos1.getLng());
    var a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(toRad(pos1.getLat())) * Math.cos(toRad(pos2.getLat())) * Math.sin(dLng / 2) * Math.sin(dLng / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; 

    return d * 1000; // 미터 단위로 반환
}

function isNearbyPos(pos1, pos2, distance) {
    return haversineDistance(pos1, pos2) <= distance;
}

// 위치 재 검색
function relocate(){
	$(".dim").show();
	$(".dim .loading-layer").show();
	try{		
		var relocate = document.querySelector("#relocate");
		relocate.style.display = "none";
				
		markers.forEach(function(marker){
			marker.setMap(null);
			clusterer.clear();
		})
		markers = [];
		removeAllCustomOverlays();
		for (var i = 0; i < keywords.length; i++) {
			ps.keywordSearch(keywords[i], placesSearchCB, {
				x: map.getCenter().getLng(),
				y: map.getCenter().getLat()
			});
		}
	}catch{
		
	}finally{
		$(".dim").hide();
		$(".dim .loading-layer").hide();
	}
	
}


function createMarker(place) {
	var imageSize = new kakao.maps.Size(35, 38),
		imageOptions = {
			spriteOrigin: new kakao.maps.Point(0, 0),
			spriteSize: new kakao.maps.Size(35, 38)
		};
	var markerImage = new kakao.maps.MarkerImage('/image/marker.png', imageSize, imageOptions);
	var marker = new kakao.maps.Marker({
		position: new kakao.maps.LatLng(place.y, place.x),
		image: markerImage
	});

	kakao.maps.event.addListener(marker, 'click', function() {
		$(".dim").show();
		$(".dim .loading-layer").show();
		getOverlay(place, marker);
	});	

    kakao.maps.event.addListener(marker, 'mouseover', function() {
		removeAllHoverOverlays();
        hoverOveray(place, marker);
    });

    kakao.maps.event.addListener(marker, 'mouseout', function() {
        removeAllHoverOverlays();
    });
	return marker;
}

function hoverOveray(place, marker){
	$.ajax({
		url: '/api/get-place-rating',
		type: 'POST',
		data: {
			place_id: place.id
		},
		success: function(data) {
			var content = '<div class="hover-overlay">'
						+ '<span class="title">' + place.place_name + '</span>';
			if(data.count > 0){
				content += '<div id="hover-rate" data-value="' + data.rating + '" data-total-stars="5" data-color="#f65e00" data-empty-color="lightgray" data-size="15px"> </div>'
			}
			content += '</div>';
			    
		    var hoverOveray = new kakao.maps.CustomOverlay({
		        position: marker.getPosition(),
		        content: content,
		        map: null,
		        yAnchor: 1.5
		    });

			currentHoverOverlay.set(0, hoverOveray);
			hoverOveray.setMap(map);
			$('#hover-rate').jstars();
		},
		error: function(error) {
			console.error('Error fetching place rating:', error);
		}
	});
}

function getOverlay(place, marker) {
	var currentPosition = marker.getPosition();

	var customOverlay = new kakao.maps.CustomOverlay({
		position:currentPosition,
		content: '',
		xAnchor: 0.5,
		yAnchor: 0,
		zIndex: 2,
		clickable: true
	});
	
	removeAllCustomOverlays();
	getPlaceInfo(place, customOverlay);
	
}

function getPlaceInfo(place, overlay) {
	$.ajax({
		url: '/api/get-place-info',
		type: 'POST',
		data: {
			place_id: place.id
		},
		success: function(data) {
			var content = ''
					    + '<div class="custom-overlay">'
					    + '    <div class="top">'
					    + '        <div class="title">'
					    + '            <span class="main-title">' + data.name + '</span>'
					    + '            <span class="sub-title">' + data.category + '</span>'
					    + '        </div>'
					    + '        <div class="close-btn"><i class="fa-solid fa-xmark"></i></div>'
					    + '    </div>'
					    + '    <div class="content">';
	
				if(data.photo_list && Object.keys(data.photo_list).length > 0){
				    content +=	  '        <div class="image-list">'
				    			+ '            <div class="image-container first">';
				    if(data.photo_list.length >= 1){
				    content +=	  '                <div class="image">'
							+ '                    <img src="' + data.photo_list[0].url + '" alt="thumbnail" onclick="imageLayerShow(this, \'' + data.name + '\', 0, ' + data.photo_list.length + ')">'
							+ '                </div>';
				    }
				    content +=	  '            </div>';
				
				    if(data.photo_list.length > 1){
				        var secondContainerClass = data.photo_list.length == 2 ? "two-img" : ""; // If there are exactly two images, add the 'two-img' class
				        content += '            <div class="image-container second ' + secondContainerClass + '">'
							+ '                <div class="row">';
				        if(data.photo_list.length >= 2){
				            content += '                    <div class="image">'
				    		 + '                        <img src="' + data.photo_list[1].url + '" alt="thumbnail" onclick="imageLayerShow(this, \'' + data.name + '\', 1, ' + data.photo_list.length + ')">'
				    		 + '                    </div>';
				        }
				        if(data.photo_list.length >= 4){
				            content += '                    <div class="image">'
				    		 + '                        <img src="' + data.photo_list[3].url + '" alt="thumbnail" onclick="imageLayerShow(this, \'' + data.name + '\', 2, ' + data.photo_list.length + ')">'
				    		 + '                    </div>';
				        }
				        content +=	  '                </div>';
				        if(data.photo_list.length > 2){
				            content += '                <div class="row">';
				            if(data.photo_list.length >= 3){
				                content += '                    <div class="image">'
				        		 + '                        <img src="' + data.photo_list[2].url + '" alt="thumbnail" onclick="imageLayerShow(this, \'' + data.name + '\', 3, ' + data.photo_list.length + ')">'
				        		 + '                    </div>';
				            }
				            if(data.photo_list.length >= 5){
				                content += '                    <div class="image">'
				        		 + '                        <img src="' + data.photo_list[4].url + '" alt="thumbnail" onclick="imageLayerShow(this, \'' + data.name + '\', 4, ' + data.photo_list.length + ')">'
				        		 + '                    </div>';
				        		 
				        		 if(data.photo_list.length > 5){
									content += '<div class="more-images">+';
									content += data.photo_list.length - 5;
									content += '</div>';
								}
				            }
				            content +=	  '                </div>';
				            
							content += '<div class="images">';
				            for(var i=5; i<data.photo_list.length; i++){
								content += '<img src="' + data.photo_list[i].url + '" alt="thumbnail" onclick="imageLayerShow(this, \'' + data.name + '\', '+ i + ', ' + data.photo_list.length + ')">'
							}
							content += '</div>';
				        }
				        content +=	  '        </div>';
				    }
				    content +=	  '    </div>';
				}


	
				// 주소
				if(data.address && Object.keys(data.address).length > 0){
					var addressFull = '';
					if(data.address.addressNo != undefined && data.address.addressNo != "")
						addressFull = data.address.addressFull + '(' + data.address.addressNo + ')';
					else
						addressFull = data.address.addressFull;
					if( addressFull != '' ){
						 content +=	 '        <div class="addr-container">'
						    	+ '            <div class="icon">'
						    	+ '                <i class="fa-solid fa-location-dot"></i>'
						    	+ '            </div>'
					    		+ '            <div class="cont">' + addressFull + '</div>'
								+ '        </div>';
					}
				}
	
	
			//영업시간
				if(Object.keys(data.open_time).length > 0 && data.open_time.dayOfWeek != ""){
				var openTimeStatus = getOpentimeStatus(data.open_time.dayOfWeek + '◆' + data.open_time.startTime + '◆' + data.open_time.endTime);
				var classStatus =  openTimeStatus == "영업전" ? "yet" : openTimeStatus == "영업 중" ? "operating" : "deadline";
			   content += '        <div class="opentime-container">'
					    + '            <div class="icon">'
					    + '                <i class="fa-solid fa-clock"></i>'
					    + '            </div>'
					    + '            <div class="cont">'
		    			+ '                <div class="status ' + classStatus + '">' + openTimeStatus + '</div>'
					    + '                <div class="opentime">' + data.open_time.dayOfWeek + ' ' + data.open_time.startTime + ' ~ ' + data.open_time.endTime + '</div>'
					    + '            </div>'
					    + '        </div>';
				}
				
				if(data.phoneNum != undefined && data.phoneNum != ""){
			   content += '        <div class="tel-container">'
					    + '            <div class="icon">'
					    + '                <i class="fa-solid fa-phone"></i>'
					    + '            </div>'
					    + '            <div class="cont">' + data.phoneNum + '</div>'
					    + '        </div>';
				}
				
				
			   content += '        <div class="comment-title">'
					    + '            <i class="fa-solid fa-face-smile"></i>'
					    + '            <div class="rate-container">'
					    + '                <span id="rate-value">0.0</span>'
					    + '                <div id="rate" data-value="' + data.comment.rating + '" data-total-stars="5" data-color="#ffb553" data-empty-color="lightgray" data-size=".9rem"> </div>'
					    + '                <span id="rate-cnt">' + data.comment.count + '건</span>'
					    + '            </div>'
					    + '            <span id="rate-ins">후기작성</span>'
					    + '        </div>'
					    + '        <div class="comment-container">';
	
	
			if (Object.keys(data.comment).length > 0 && data.comment.comments.length > 0) {
			    for (var i = 0; i < data.comment.count; i++) {
			        content += '<div class="list">'
			            + '<div class="image">';
			        if (data.comment.comments[i].imagePath != undefined && data.comment.comments[i].imagePath != "") {
			            content += '<img src="' + data.comment.comments[i].imagePath + '" alt="thumbnail" onclick="commentImageLayerShow(this)" >';
			        }
			        content += '</div>'
			            + '<div class="cont-container">'
			            + '<div class="top">'
			            + '<div class="nickname">'
			            + '<span class="rating">★' + data.comment.comments[i].rating + '</span>'
			            + '<b>' + data.comment.comments[i].user.nickname + '</b>'
			            + '</div>'
			            + '<div class="dt">' + timeAgo(data.comment.comments[i].createTm) + '</div>'
			            + '</div>'
			            + '<div class="cont">'
			            + data.comment.comments[i].comment
			            + '<div class="fade-out">'
			            + '<button class="more-btn">더보기...</button>'
			            + '</div>'
			            + '</div>'
			            + '</div>'
			            + '</div>';
			    }
			}
	
		   	content += '    </div>'
				    + '</div>';
	
			currentOverlay.set(0, overlay);	
			overlay.setContent(content);
			
			overlay.setMap(map);
			
			var currentPosition = overlay.getPosition();
	
			map.setCenter(currentPosition);
			$(".custom-overlay").hide().fadeIn(300);
			if(document.querySelector(".custom-overlay") != null){
				// 마우스가 오버레이에 진입하면 원래의 스크롤 기능 비활성화
				document.querySelector(".custom-overlay").addEventListener('mouseenter', function() {
				  map.setZoomable(false);
				});
				
				// 마우스가 오버레이에서 벗어나면 원래의 스크롤 기능 활성화
				document.querySelector(".custom-overlay").addEventListener('mouseleave', function() {
				  map.setZoomable(true);
				});
	
				//닫기 버튼
				document.querySelector(".custom-overlay .close-btn").addEventListener("click", function(){
					$(".custom-overlay").fadeOut(300, function(){					
						removeAllCustomOverlays();
					});
				});
			}

			//별점 표시
			$('#rate').jstars().setValue(data.comment.rating);
			$('#rate-value').text(data.comment.rating);
			
			$(".dim").hide();
			$(".dim .loading-layer").hide();
		},
		error: function(error) {
			$(".dim").hide();
			$(".dim .loading-layer").hide();			
			console.error('Error fetching image URL:', error);
		}
	});
}

// 더보기 버튼 활성함수
function isTextTruncated(element) {
    const { scrollHeight, clientHeight } = element;
    return scrollHeight > clientHeight;
}

function moreBtnShow(element){
	element.querySelector(".fade-out").classList.toggle("show");	
}

function addClickEventMoreBtnShow(element){
	var moreBtn = element.querySelector(".more-btn");
	moreBtn.addEventListener("click", function(){		
		if(element.classList.contains("more")){
			element.classList.remove("more");
			moreBtn.innerHTML = "더보기...";
		}else{
			element.classList.add("more");
			moreBtn.innerHTML = "간략히...";
		}
	});
}

// 영업 상태 리턴 함수
// getOpentimeStatus("월◆09:00◆18:00")
// getOpentimeStatus("월~금◆09:00◆18:00")
// getOpentimeStatus("월,목,일◆09:00◆18:00")
function getDayOfWeekString(day) {
  switch (day) {
    case 0: return "일";
    case 1: return "월";
    case 2: return "화";
    case 3: return "수";
    case 4: return "목";
    case 5: return "금";
    case 6: return "토";
    default: return "";
  }
}

function getDays(days){
	var day = ['월', '화', '수', '목', '금', '토', '일'];
	//월~수
	if(days.includes("~")){
		var startDay = days.split("~")[0];
		var endDay = days.split("~")[1];
		var str = "";
		
		switch (startDay) {
		    case "월":
				startDay = 0;
				break;
			case "화":
				startDay = 1;
				break;
			case "수":
				startDay = 2;
				break;
			case "목":
				startDay = 3;
				break;
			case "금":
				startDay = 4;
				break;
			case "토":
				startDay = 5;
				break;
			case "일":
				startDay = 6;
				break;
  		}
  		
  		switch (endDay) {
		    case "월":
				endDay = 0;
				break;
			case "화":
				endDay = 1;
				break;
			case "수":
				endDay = 2;
				break;
			case "목":
				endDay = 3;
				break;
			case "금":
				endDay = 4;
				break;
			case "토":
				endDay = 5;
				break;
			case "일":
				endDay = 6;
				break;
  		}
	  		
		for(var i=startDay; i<=endDay; i++){
			str += day[i] + ",";
		}
		return str;
	}else{
		return days;
	}
}

function parseTime(timeString) {
  var timeComponents = timeString.split(':');
  return {
    hour: parseInt(timeComponents[0], 10),
    minute: parseInt(timeComponents[1], 10)
  };
}

function getOpentimeStatus(timeRangeString) {
  var now = new Date();
  var currentDay = getDayOfWeekString(now.getDay());
  var currentTime = now.getHours() * 60 + now.getMinutes();

  var timeRanges = timeRangeString.split('◆');
  var days = getDays(timeRanges[0]).split(/,|~/);
  var openTime = parseTime(timeRanges[1]);
  var closeTime = parseTime(timeRanges[2]);

  var isOpen = days=="매일"?true:false;
  
  for (var i = 0; i < days.length; i++) {
    if (days[i].includes(currentDay)) {
      isOpen = true;
      break;
    }
  }

  if (!isOpen) {
    return "금일영업마감";
  }

  var openTimeInMinutes = openTime.hour * 60 + openTime.minute;
  var closeTimeInMinutes = closeTime.hour * 60 + closeTime.minute;
  if(closeTimeInMinutes < openTimeInMinutes){
	  closeTimeInMinutes += 24 * 60;
  }
  if (currentTime < openTimeInMinutes) {
    return "영업 전";
  } else if (currentTime >= openTimeInMinutes && currentTime < closeTimeInMinutes) {
    return "영업 중";
  } else {
    return "금일영업마감";
  }
}

//모든 커스텀 오버레이 삭제
function removeAllCustomOverlays() {
  currentOverlay.forEach(function(co, uniqueKey) {
    co.setMap(null);
    currentOverlay.delete(uniqueKey);
  });
}

//모든 마우스오버 오버레이 삭제
function removeAllHoverOverlays(){
	currentHoverOverlay.forEach(function(ho, uniqueKey) {
    	ho.setMap(null);
    	currentHoverOverlay.delete(uniqueKey);
  	});
  	document.querySelectorAll(".hover-overlay").forEach(function(overlay){
	  overlay.parentElement.remove();
  	})
}

// 이미지 확대 레이어
function imageLayerShow(image, titleStr, current, allCnt){
    var imgLayer = document.querySelector(".dim .image-layer");
    var img = document.querySelector(".dim .image-layer .image img");
    var newImg = new Image();

    newImg.onload = function() {
        img.src = this.src;

        var maxWidth = window.innerWidth * 0.9;
        var maxHeight = window.innerHeight * 0.9;
        var ratio = this.width / this.height;

        var targetWidth = Math.min(maxWidth, this.width);
        var targetHeight = targetWidth / ratio;

        if (targetHeight > maxHeight) {
            targetHeight = maxHeight;
            targetWidth = targetHeight * ratio;
        }

        imgLayer.style.width = targetWidth + 'px';
        imgLayer.style.height = targetHeight + 'px';

        imgLayer.dataset.allcnt = allCnt;
        imgLayer.dataset.current = current;
        prevNextBtn();
    }
    
    if(imgLayer.style.display == "none" || imgLayer.style.display == ""){
        $(".dim").css("display", "flex").hide().fadeIn("fast", function(){
            $(".dim .image-layer").css("display", "flex").hide().fadeIn(function(){
				this.style.transition = "all 0.3s ease";
	            this.style.WebkitTransition = "all 0.3s ease";
	            this.style.MozTransition = "all 0.3s ease";
	            this.style.MsTransition = "all 0.3s ease";
	            this.style.OTransition = "all 0.3s ease";
			});
        });
    }

    newImg.src = image.getAttribute("src");
}

// 댓글 이미지 확대 레이어
function commentImageLayerShow(image){
    var imgLayer = document.querySelector(".dim .image-layer");
    var img = document.querySelector(".dim .image-layer .image img");
    var newImg = new Image(); 
    newImg.onload = function() {
        img.src = this.src;

        var maxWidth = window.innerWidth * 0.9;
        var maxHeight = window.innerHeight * 0.9;
        var ratio = this.width / this.height;

        var targetWidth = Math.min(maxWidth, this.width);
        var targetHeight = targetWidth / ratio;

        if (targetHeight > maxHeight) {
            targetHeight = maxHeight;
            targetWidth = targetHeight * ratio;
        }

        imgLayer.style.width = targetWidth + 'px';
        imgLayer.style.height = targetHeight + 'px';
        
        prevNextBtn();
    }
    
    if(imgLayer.style.display == "none" || imgLayer.style.display == ""){
        $(".dim").css("display", "flex").hide().fadeIn("fast", function(){
            $(".dim .image-layer").css("display", "flex").hide().fadeIn(function(){
				this.style.transition = "all 0.3s ease";
	            this.style.WebkitTransition = "all 0.3s ease";
	            this.style.MozTransition = "all 0.3s ease";
	            this.style.MsTransition = "all 0.3s ease";
	            this.style.OTransition = "all 0.3s ease";
			});
        });
    }

    newImg.src = image.getAttribute("src");
}



// 이전, 다음 버튼활성화 함수
function prevNextBtn(){
	var imgLayer = document.querySelector(".dim .image-layer");
	var allCnt = parseInt(imgLayer.dataset.allcnt);
	// 0부터 시작하기때문에 +1 하였음
	var current = parseInt(imgLayer.dataset.current) + 1;
	var leftBtn = document.querySelector(".dim .image-layer .btns .left");
	var rightBtn = document.querySelector(".dim .image-layer .btns .right");
	
	if(allCnt >= 2){
		if(current == 1){
			leftBtn.style.display = "none";
			rightBtn.style.display = "block";
		}else if(current == allCnt){
			leftBtn.style.display = "block";
			rightBtn.style.display = "none";	
		}else{
			leftBtn.style.display = "block";
			rightBtn.style.display = "block";
		}
	}else{
		leftBtn.style.display = "none";
		rightBtn.style.display = "none";
	}
}


// 이전, 다음 이미지 넘기기 함수
function prevNextImage(i){
	var imgs = document.querySelectorAll(".custom-overlay .image-list .image img, .custom-overlay .image-list .images img");
	imgs[i].click();
}