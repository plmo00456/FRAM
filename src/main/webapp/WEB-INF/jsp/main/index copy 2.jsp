<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=809f9156aabae419a6e977cd60ecfcd3&libraries=services,clusterer"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link href="/css/main/map.css" rel="stylesheet" type="text/css" />
    <link href="/css/util/rating.css" rel="stylesheet" type="text/css" />
    <script src="/js/util/rating.js"></script>
    <script src="/js/main/map.js"></script>

    <script>
      window.onload = function() {
        starRating("starRating", 4.4);
      }
    </script>
  </head>
  <body>
    <div class="star-rating" id="starRating"></div>
    <div id="map" class="map"></div>
  </body>
</html>