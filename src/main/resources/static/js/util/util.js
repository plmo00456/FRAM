// "10초 전", "1분 전", "1시간 전" 등으로 표시
function timeAgo(serverTime) {
	const currentTime = new Date();
	const serverDate = new Date(serverTime);
	const seconds = Math.floor((currentTime - serverDate) / 1000);

	let interval = seconds / 31536000;

	if (interval > 1) {
		return Math.floor(interval) + " 년 전";
	}
	interval = seconds / 2592000;
	if (interval > 1) {
		return Math.floor(interval) + " 개월 전";
	}
	interval = seconds / 86400;
	if (interval > 1) {
		return Math.floor(interval) + " 일 전";
	}
	interval = seconds / 3600;
	if (interval > 1) {
		return Math.floor(interval) + " 시간 전";
	}
	interval = seconds / 60;
	if (interval > 1) {
		return Math.floor(interval) + " 분 전";
	}
	return Math.floor(seconds) + " 초 전";
}

function removeParam(urlString, paramName) {
	let url = new URL(urlString);
	url.searchParams.delete(paramName);
	return url.toString();
}

function isEmpty(value, stringWithTrue) {
	try {
		const isEmptyValue = (
			value === undefined ||
			value === null ||
			(typeof value === "string" && value.trim().length === 0) ||
			(Array.isArray(value) && value.length === 0) ||
			(typeof value === "object" && Object.keys(value).length === 0)
		);
	
		if (isEmptyValue) {
			if (stringWithTrue === undefined) {
				return true;
			} else {
				return stringWithTrue;
			}
		}
		return value;
	}catch(e){
		if (stringWithTrue === undefined) {
			return true;
		} else {
			return stringWithTrue;
		}
	}
}

function provideKr(provide) {
	if (provide == "naver") return "네이버";
	else if (provide == "카카오") return "카카오";
	else if (provide == "google") return "구글";
	else return provide;
}

function requiredClass(ele) {
	if (ele.value == "") {
		ele.classList.add("required");
		ele.focus();
		return false;
	} else {
		ele.classList.remove("required");
		return true;
	}
}

// 내 정보 가져오기
function getUserInfo(mode) {
	var result;
	var loginLayerBtn = document.querySelector(".login-layer-btn");
	$.ajax({
		url: '/api/auth/getMe',
		type: 'POST',
		contentType: 'application/json',
		async: false,
		success: function(data) {
			if (data.status == "Y") {
				result = data;
			} else {
				if (mode == "login") {
					if (loginLayerBtn) {
						loginLayerBtn.click();
					} else {
						document.cookie = 'refreshToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
						document.cookie = 'accessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
						window.location.hash = 'relogin';
						window.location.reload();
					}
				}
			}
		},
		error: function(error) {
			if (mode == "login") {
				if (loginLayerBtn) {
					loginLayerBtn.click();
				} else {
					document.cookie = 'refreshToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
					document.cookie = 'accessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
					window.location.hash = 'relogin';
					window.location.reload();
				}
			}
		}
	});
	return result;
}