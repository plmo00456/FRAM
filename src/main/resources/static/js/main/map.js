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
					content += '<div id="hover-rate" data-value="' + data.rating + '" data-total-stars="5" data-color="#f65e00" data-empty-color="lightgray" data-size="15px"> </div>'
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
	if (currentOverlay === customOverlay) {
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
				+ ' <div class = "custom-overlay">'
				+ '     <div class = "title"> ' + place.place_name + ' </div>'
				+ '     <div class = "image">'
				+ '         <img src = "' + data.photo_list[0].orgurl + '" alt = "thumbnail" width = "80px" height = "80px">'
				+ '     </div>'
				+ ' </div>';
			overlay.setContent(content);
			// 새로운 오버레이를 엽니다.
			overlay.setMap(map);
			// 현재 열려 있는 오버레이를 업데이트합니다.
			currentOverlay = overlay;

			//별점 표시
			$('#rate').jstars().setValue(data.rating.value);
			$('#rate-value').text(data.rating.value);
		},
		error: function(error) {
			console.error('Error fetching image URL:', error);
		}
	});
}