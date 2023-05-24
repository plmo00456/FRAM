package com.main.Controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MainController {
	
	@Value("${kakao.api.appkey}")
	private String kakaoAppKey;
	
	@GetMapping("/")
	public ModelAndView main(ModelAndView mav) {
		mav.addObject("kakaoAppKey", kakaoAppKey);
		mav.addObject("currentMenu", "1000000");
		
		mav.setViewName("main/index");
		return mav;
	}
}
