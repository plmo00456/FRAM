<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services,clusterer"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/plugin/star-rating/jstars.js"></script>

    <link href="/css/main/map.css" rel="stylesheet" type="text/css" />
    <script src="/js/main/map.js"></script>

    <script>
      $(document).ready(function() {
        // 맵 표시
        getUserLocation();
      });
    </script>
  </head>
  <body>
    <div id="rate"
        data-value="0"
        data-total-stars="5"
        data-color="#f65e00"
        data-empty-color="lightgray"
        data-size="30px">
    </div>
    <span id="rate-value">0</span>

    <div id="map" class="map"></div>

    <div class="overlay">
      .
    </div>
  </body>
</html>