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