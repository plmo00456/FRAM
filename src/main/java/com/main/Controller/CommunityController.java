package com.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class CommunityController {

	@GetMapping("/commu")
	public ModelAndView CommunityMain(ModelAndView mav) {
		mav.setViewName("main/index");
		return mav;
	}
}
