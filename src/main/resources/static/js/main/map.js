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
var currentOverlay = null; // 현재 열려 있는 오버레이
var currentHoverOverlay = null; // 현재 열려 있는 마우스오버 오버레이
var markers = [];   // 마커

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
	mapInitChk = true;
	mapContainer = document.querySelector("#map");
	map = new kakao.maps.Map(mapContainer, mapOption);
	ps = new kakao.maps.services.Places();
	ps.keywordSearch('맛집', placesSearchCB, {
		x: longitude,
		y: latitude
	});
	map.setMinLevel(1);
	map.setMaxLevel(10);
	map.setCenter(new kakao.maps.LatLng(latitude, longitude));
	map.setLevel(4);
	clusterer = new kakao.maps.MarkerClusterer({
		map: map,
		averageCenter: true,
		minLevel: 4,
		minClusterSize: 2
	});
	if (locYn) {
		var userMarkerPosition = new kakao.maps.LatLng(latitude, longitude);
		userMarker = new kakao.maps.Marker({
			position: userMarkerPosition
		});
		userMarker.setMap(map);
	}
	$('#rate').jstars();
}

function placesSearchCB(data, status, pagination) {
	if (status === kakao.maps.services.Status.OK) {
		for (var i = 0; i < data.length; i++) {
			//마커 추가
			markers.push(createMarker(data[i]));
			//클러스터 추가
			clusterer.addMarkers(markers);
		}
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
		getOverlay(place, marker);
	});
	
	

    kakao.maps.event.addListener(marker, 'mouseover', function() {
        hoverOveray(1, place, marker);
    });

    kakao.maps.event.addListener(marker, 'mouseout', function() {
        hoverOveray(0, place, marker);
    });
	return marker;
}

function hoverOveray(mode, place, marker){
    
	if(mode == 1){
		
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
					content += '<div id="hover-rate" data-value="' + data.comment.rating + '" data-total-stars="5" data-color="#f65e00" data-empty-color="lightgray" data-size="15px"> </div>'
				}
				content += '</div>';
				    
			    var hoverOveray = new kakao.maps.CustomOverlay({
			        position: marker.getPosition(),
			        content: content,
			        map: null,
			        yAnchor: 1.5
			    });
				hoverOveray.setMap(map);
				currentHoverOveray = hoverOveray;
				$('#hover-rate').jstars();
			},
			error: function(error) {
				console.error('Error fetching place rating:', error);
			}
		});
		
	}else{
		currentHoverOveray.setMap(null);
		currentHoverOveray = null;
	}
}

function getOverlay(place, marker) {
	var customOverlay = new kakao.maps.CustomOverlay({
		position: marker.getPosition(),
		content: '',
		xAnchor: 0.5,
		yAnchor: 0,
		zIndex: 2,
		clickable: true
	});

	// 열려 있는 오버레이가 있으면 닫기
	if (currentOverlay == customOverlay) {
		customOverlay.setMap(null);
		currentOverlay = null;
	} else {
		if (currentOverlay) {
			currentOverlay.setMap(null);
		}
		getPlaceInfo(place, customOverlay);
	}
}

function getPlaceInfo(place, overlay) {
	$.ajax({
		url: '/api/get-place-info',
		type: 'POST',
		data: {
			place_id: place.id
		},
		success: function(data) {
			var imageURL = data;
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
	
				if(data.photo_list != undefined && data.photo_list.length > 0){
				    content +=	  '        <div class="image-list">'
			    				+ '            <div class="image-container first">';
					if(data.photo_list.length >= 1){
					content +=	  '                <div class="image">'
							    + '                    <img src="' + data.photo_list[0].orgurl + '" alt="thumbnail">'
							    + '                </div>';
					}
					content +=	  '            </div>'
							    + '            <div class="image-container second">'
								+ '                <div class="row">';
					if(data.photo_list.length >= 2){
					    content += '                    <div class="image">'
		    					 + '                        <img src="' + data.photo_list[1].orgurl + '" alt="thumbnail">'
					    		 + '                    </div>';
					}
					if(data.photo_list.length >= 3){
						content += '                    <div class="image">'
		    					 + '                        <img src="' + data.photo_list[2].orgurl + '" alt="thumbnail">'
					    		 + '                    </div>';
					}
					content +=	  '                </div>'
								+ '                <div class="row">';
					if(data.photo_list.length >= 4){
					    content += '                    <div class="image">'
		    					 + '                        <img src="' + data.photo_list[3].orgurl + '" alt="thumbnail">'
					    		 + '                    </div>';
					}
					if(data.photo_list.length >= 5){
						content += '                    <div class="image">'
		    					 + '                        <img src="' + data.photo_list[4].orgurl + '" alt="thumbnail">'
					    		 + '                    </div>';
					}
					content +=	  '                </div>';
					content +=	  '        </div>';
					content +=	  '    </div>';
				}
	
			// 주소
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
	
	
			//영업시간
				if(data.open_time != undefined && data.open_time.dayOfWeek != ""){
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
					    + '        </div>'
					    + '        <div class="comment-container">';
	
	
			if(data.phoneNum != undefined && data.phoneNum != ""){
				for(var i=0; i<data.comment.count; i++){					
				   content += '        <div class="list">'
						    + '                <div class="image">'
						    + '                    <img src="' + data.comment.comments[i].imagePath + '" alt="thumbnail">'
						    + '                </div>'
						    + '                <div class="cont-container">'
						    + '                    <div class="top">'
						    + '                        <div class="nickname">'
						    + '                            <span class="rating">★' + data.comment.comments[i].rating + '</span>'
						    + '                            <b>' + data.comment.comments[i].users.name + '</b>'
						    + '                        </div>'
						    + '                        <div class="dt">' + timeAgo(data.comment.commenets[i].createTm)  + '</div>'
						    + '                    </div>'
						    + '                    <div class="cont">'
						    + '                        '+ data.comment.comments[i].comment
						    + '                        <div class="fade-out">'
						    + '                            <button class="more-btn">더보기...</button>'
						    + '                        </div>'
						    + '                    </div>'
						    + '                </div>'
						    + '            </div>'
						    + '        </div>';
				}
			}
	
			   content += '    </div>'
					    + '</div>';
			overlay.setContent(content);
			overlay.setMap(map);
			currentOverlay = overlay;

			//닫기 버튼
			document.querySelector(".custom-overlay .close-btn").addEventListener("click", function(){
				overlay.setMap(null);
				currentOverlay = null;
			});

			//별점 표시
			$('#rate').jstars().setValue(data.comment.rating);
			$('#rate-value').text(data.comment.rating);
		},
		error: function(error) {
			console.log(1);
			console.error('Error fetching image URL:', error);
		}
	});
}

// 더보기 버튼 활성함
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
  var days = timeRanges[0].split(/,|~/);
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

  if (currentTime < openTimeInMinutes) {
    return "영업 전";
  } else if (currentTime >= openTimeInMinutes && currentTime < closeTimeInMinutes) {
    return "영업 중";
  } else {
    return "금일영업마감";
  }
}