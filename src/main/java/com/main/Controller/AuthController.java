package com.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AuthController {

	
	@GetMapping("/auth/login")
	public ModelAndView LoginLayer(ModelAndView mav) {
		
		mav.setViewName("auth/login-layer");
		return mav;
	}
}
