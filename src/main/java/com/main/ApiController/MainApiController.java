package com.main.ApiController;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.main.service.CommentService;
import com.main.service.UsersService;
import com.main.vo.Comment;

@RestController
@RequestMapping("/api")
public class MainApiController {
	
	@Autowired
	private UsersService us;
	
	@Autowired
	private CommentService cs;
	
	@PostMapping("/get-place-info")
	public ResponseEntity<String> GetPlaceInfo(@RequestParam(value="place_id", required = false) String placeId) {
		Gson gson = new Gson();
		JsonObject result = new JsonObject();
		result.addProperty("status", "N");
		
		try {
			String urlStr = "https://place.map.kakao.com/main/v/" + placeId;
	        URL url = new URL(urlStr);
	        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			
            JsonObject data = gson.fromJson(new InputStreamReader(connection.getInputStream()), JsonObject.class);
            
            //이미지 목록
            JsonArray photoList = new JsonArray();
            try {
	            if (data.has("photo")) {
		            photoList = data.getAsJsonObject("photo")
		            .getAsJsonArray("photoList")
		            .get(0)
		            .getAsJsonObject()
		            .getAsJsonArray("list");
	            }
            }catch(Exception e) {}
            result.add("photo_list", photoList);
            

            // 카카오 평가 점수
            JsonObject rating = new JsonObject();
            try {
	            if (data.has("comment")) {
		            // 평가 수
		            int scorecnt = data.getAsJsonObject("comment").get("scorecnt").getAsInt();
		            // 총 평점
		            int scoresum = data.getAsJsonObject("comment").get("scoresum").getAsInt();
		            // 평점
		            float value = scorecnt == 0 ? 0 : Float.parseFloat(String.format("%.1f", (double)scoresum / (double)scorecnt));
	
		            rating.addProperty("cnt", scorecnt);
		            rating.addProperty("sum", scoresum);
		            rating.addProperty("value", value);
	            }
            }catch(Exception e) {}
            result.add("rating", rating);
            
            // 영업시간
            JsonObject openTime = new JsonObject();
            try {
	            if (data.getAsJsonObject("basicInfo").has("openHour")) {
	            	JsonObject timeInfo = data.getAsJsonObject("basicInfo").getAsJsonObject("openHour")
	            			.getAsJsonArray("periodList").get(0).getAsJsonObject()
	            			.getAsJsonArray("timeList").get(0).getAsJsonObject();
	            	
	            	// 영업 시간 00:00 ~ 23:59
	            	String time = timeInfo.get("timeSE").getAsString();
	            	// 오픈 시간 00:00
	            	String startTime = time.split(" ~ ")[0];
	            	// 클로즈 시간 23:59
	            	String endTime = time.split(" ~ ")[1];
	            	// 영업일 금~일
	            	String dayOfWeek = timeInfo.get("dayOfWeek").getAsString();
	            	
	            	openTime.addProperty("startTime", startTime);
	            	openTime.addProperty("endTime", endTime);
	            	openTime.addProperty("dayOfWeek", dayOfWeek);
	            }
			}catch(Exception e) {}
            result.add("open_time", openTime);
            
            
            // 주소
            JsonObject address = new JsonObject();
            try {
	            if (data.getAsJsonObject("basicInfo").has("address")) {
	            	JsonObject addressInfo = data.getAsJsonObject("basicInfo").getAsJsonObject("address").getAsJsonObject("newaddr");
	            	
	            	// 도로명 주소 
	            	String addressFull = addressInfo.get("newaddrfull").getAsString();
	            	// 우편번호
	            	String addressNo = addressInfo.get("bsizonno").getAsString();
	            	
	            	address.addProperty("addressFull", addressFull);
	            	address.addProperty("addressNo", addressNo);
	            }
	            result.add("address", address);
			}catch(Exception e) {}

            // 전화번호
            try {
	            if (data.getAsJsonObject("basicInfo").has("phonenum")) {
	            	String phoneNum = data.getAsJsonObject("basicInfo").get("phonenum").getAsString();
	            	result.addProperty("phoneNum", phoneNum);
	            }else {
	            	result.addProperty("phoneNum", "");
	            }
            }catch(Exception e) {}
            
            result.addProperty("status", "Y");
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
	}
	
	@PostMapping("/get-place-rating")
	public ResponseEntity<String> GetRating(@RequestParam(value="place_id", required = false) Integer placeId) {
		Gson gson = new Gson();
		JsonObject result = new JsonObject();
		result.addProperty("status", "N");
		
		try {
			List<Comment> comments = cs.getComments(placeId);
			double rating = 0;
			for(int i=0; i<comments.size(); i++)
				rating += comments.get(i).getRating();
			rating = comments.size() > 0 ? rating / comments.size() : 0; 
			
			JsonArray jArrayComments = gson.toJsonTree(comments).getAsJsonArray();
			result.addProperty("count", comments.size());
			result.addProperty("rating", rating);
			result.add("comments", jArrayComments);
			result.addProperty("status", "Y");
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
	}
	
}
