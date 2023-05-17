package com.main.Controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AuthController {
	@Value("${naver.api.clientid}")
	private String naverClientId;
	@Value("${kakao.api.appkey}")
	private String kakaoClientId;
	@Value("${google.api.clientid}")
	private String googleClientId;
	
	@GetMapping("/auth/login")
	public ModelAndView LoginLayer(ModelAndView mav) {
		mav.addObject("naverClientId", naverClientId);
		mav.addObject("kakaoClientId", kakaoClientId);
		mav.addObject("googleClientId", googleClientId);
		mav.setViewName("auth/login-layer");
		return mav;
	}
}
