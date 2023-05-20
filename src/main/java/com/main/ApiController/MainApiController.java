package com.main.ApiController;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.main.JwtUtil.CustomUserDetails;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.service.CommentService;
import com.main.service.UsersLocationService;
import com.main.service.UsersService;
import com.main.utils.LocalDateTimeSerializer;
import com.main.utils.Utils;
import com.main.vo.Comment;
import com.main.vo.Users;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class MainApiController {
	
	@Autowired
	private UsersService us;
	
	@Autowired
	private UsersLocationService uls;
	
	@Autowired
	private CommentService cs;
	
	private final JwtTokenProvider jwtTokenProvider;
	
	@PostMapping("/get-place-info")
	public ResponseEntity<String> GetPlaceInfo(@RequestBody Map<String, Object> formData) {
		Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
                .create();
		JsonObject result = new JsonObject();
		result.addProperty("status", "N");
		
		try {
			String urlStr = "https://place.map.kakao.com/main/v/" + formData.get("placeId");
	        URL url = new URL(urlStr);
	        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			
            JsonObject data = gson.fromJson(new InputStreamReader(connection.getInputStream()), JsonObject.class);
            
            urlStr = "https://place.map.kakao.com/photolist/v/" + formData.get("placeId");
	        url = new URL(urlStr);
	        connection = (HttpURLConnection) url.openConnection();
	        connection.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			
            JsonObject photos = gson.fromJson(new InputStreamReader(connection.getInputStream()), JsonObject.class);
            
            //이미지 목록
            JsonArray photoList = new JsonArray();
            try {
	            if (photos.has("photoViewer")) {
		            photoList = photos.getAsJsonObject("photoViewer")
		            .getAsJsonArray("list");
	            }
            }catch(Exception e) {}
            result.add("photo_list", photoList);

            // 카카오 평가 점수
            JsonObject kRating = new JsonObject();
            try {
	            if (data.has("comment")) {
		            // 평가 수
		            int scorecnt = data.getAsJsonObject("comment").get("scorecnt").getAsInt();
		            // 총 평점
		            int scoresum = data.getAsJsonObject("comment").get("scoresum").getAsInt();
		            // 평점
		            float value = scorecnt == 0 ? 0 : Float.parseFloat(String.format("%.1f", (double)scoresum / (double)scorecnt));
	
		            kRating.addProperty("cnt", scorecnt);
		            kRating.addProperty("sum", scoresum);
		            kRating.addProperty("value", value);
	            }
            }catch(Exception e) {}
            result.add("kakao-rating", kRating);
            
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
            	String addressFull = "";
            	if (data.getAsJsonObject("basicInfo").has("address")) {
            		JsonObject addressRegion = data.getAsJsonObject("basicInfo").getAsJsonObject("address").getAsJsonObject("region");
            		JsonObject addressInfo = data.getAsJsonObject("basicInfo").getAsJsonObject("address").getAsJsonObject("newaddr");
            		
            		// 도로명 주소 1
            		addressFull += addressRegion.get("newaddrfullname").getAsString() + " ";	            
	            	// 도로명 주소 2
	            	addressFull += addressInfo.get("newaddrfull").getAsString();
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
            
            // 식당 명
            try {
	            if (data.getAsJsonObject("basicInfo").has("placenamefull")) {
	            	String name = data.getAsJsonObject("basicInfo").get("placenamefull").getAsString();
	            	result.addProperty("name", name);
	            }else {
	            	result.addProperty("name", "");
	            }
            }catch(Exception e) {}
            
            // 식당 카테고리
            try {
	            if (data.getAsJsonObject("basicInfo").has("category")) {
	            	String cateName = data.getAsJsonObject("basicInfo").getAsJsonObject("category").get("catename").getAsString();
	            	result.addProperty("category", cateName);
	            }else {
	            	result.addProperty("category", "");
	            }
            }catch(Exception e) {}
            
            // 로컬 평점
            JsonObject comment = new JsonObject();
            try {
            	List<Comment> comments = cs.findCommentsByPlaceIdWithUser(Integer.parseInt(formData.get("placeId")+""));
            	double ratingValue = 0;
            	for(int i=0; i<comments.size(); i++)
            		ratingValue += comments.get(i).getRating();
            	ratingValue = comments.size() > 0 ? ratingValue / comments.size() : 0; 
            	
            	JsonArray jArrayComments = gson.toJsonTree(comments).getAsJsonArray();
            	comment.addProperty("count", comments.size());
            	comment.addProperty("rating", String.format("%.1f", ratingValue));
            	comment.add("comments", jArrayComments);
            	
            	result.add("comment", comment);
            }catch(Exception e) {}
            
            
            result.addProperty("status", "Y");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
	}
	
	@PostMapping("/get-place-rating")
	public ResponseEntity<String> GetRating(@RequestBody Map<String, Object> formData) {
		Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
                .create();
		JsonObject result = new JsonObject();
		result.addProperty("status", "N");
		
		try {
			List<Comment> comments = cs.findCommentsByPlaceIdWithUser(Integer.parseInt(formData.get("placeId")+""));
			double rating = 0;
			for(int i=0; i<comments.size(); i++)
				rating += comments.get(i).getRating();
			rating = comments.size() > 0 ? rating / comments.size() : 0; 
			
			JsonArray jArrayComments = gson.toJsonTree(comments).getAsJsonArray();
			result.addProperty("count", comments.size());
			result.addProperty("rating", String.format("%.1f", rating));
			result.add("comment", jArrayComments);
			result.addProperty("status", "Y");
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
	}
	
	@PostMapping("/set-user-location")
	public ResponseEntity<String> SetUserLocation(HttpServletRequest req, HttpServletResponse res, @RequestBody Map<String, String> formData) {
		Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
                .create();
		JsonObject result = new JsonObject();
		Optional<Cookie> accessTokenCookie = Utils.getHttpOnlyCookie(req, "accessToken");
		String accessToken = "";
		result.addProperty("status", "N");
		if (accessTokenCookie.isPresent()) {
			try {				
				accessToken = accessTokenCookie.get().getValue();
				Authentication auth = jwtTokenProvider.getAuthentication(accessToken);
				boolean validateToken = jwtTokenProvider.validateToken(accessToken);
				if (accessToken != null && validateToken) {
					try {
						auth = jwtTokenProvider.getAuthentication(accessToken);
						
						Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
						CustomUserDetails userInfo = ((CustomUserDetails)principal);
						Long seq = userInfo.getSeq();
						if(seq != null && userInfo != null) {
							Optional<Users> user = us.getUser(userInfo.getSeq());
							if(user.isPresent()) {
								uls.insertUpdateUserLocation(seq, formData.get("lat"), formData.get("lon"));
								result.addProperty("status", "Y");
							}else {
								throw new Exception("오류");
							}
						}else {
							throw new Exception("오류");
						}
						
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					} catch (Exception e) {
						e.printStackTrace();
						result.addProperty("msg", "로그인이 만료되었습니다.<br>다시 로그인 해주세요.");
						result.addProperty("code", "001");
						e.fillInStackTrace();
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					}
				} else {
					result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
					result.addProperty("code", "002");
					return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
				}
			}catch(Exception e) {
				result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
				result.addProperty("code", "002");
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			}
		}else {
			result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
			result.addProperty("code", "002");
			return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
		}
	}
	
	@PostMapping("/place/set-comment")
	public ResponseEntity<String> setComment(HttpServletRequest req, HttpServletResponse res, @RequestBody Map<String, String> commentForm) {
		Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
                .create();
		JsonObject result = new JsonObject();
		Optional<Cookie> accessTokenCookie = Utils.getHttpOnlyCookie(req, "accessToken");
		String accessToken = "";
		result.addProperty("status", "N");
		if (accessTokenCookie.isPresent()) {
			try {
				accessToken = accessTokenCookie.get().getValue();
				Authentication auth = jwtTokenProvider.getAuthentication(accessToken);
				boolean validateToken = jwtTokenProvider.validateToken(accessToken);
				if (accessToken != null && validateToken) {
					try {
						auth = jwtTokenProvider.getAuthentication(accessToken);
						
						Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
						CustomUserDetails userInfo = ((CustomUserDetails)principal);
						Long seq = userInfo.getSeq();
						if(seq != null && userInfo != null) {
							Optional<Users> user = us.getUser(userInfo.getSeq());
							if(user.isPresent()) {
								Users userDetail = user.get();
								
								Comment comment = new Comment();
								comment.setPlaceId(Integer.parseInt(commentForm.get("placeId")));
								comment.setUserSeq(userDetail.getSeq());
								comment.setRating(Double.parseDouble(commentForm.get("rating")));
								comment.setComment(commentForm.get("comment"));
								comment.setUseYn("Y");
								cs.insertComment(comment);
								result.addProperty("status", "Y");
							}else {
								throw new Exception("오류");
							}
						}else {
							throw new Exception("오류");
						}
						
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					} catch (Exception e) {
						e.printStackTrace();
						result.addProperty("msg", "로그인이 만료되었습니다.<br>다시 로그인 해주세요.");
						result.addProperty("code", "001");
						e.fillInStackTrace();
						return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
					}
				} else {
					result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
					result.addProperty("code", "002");
					return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
				}
			}catch(Exception e) {
				result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
				result.addProperty("code", "002");
				return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
			}
		}else {
			result.addProperty("msg", "잘못된 계정 정보입니다.<br>다시 로그인 해주세요.");
			result.addProperty("code", "002");
			return ResponseEntity.ok().header("Content-Type", "application/json").body(gson.toJson(result));
		}
	}
	
}
