package com.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping("/terms")
@Controller
public class TermsController {
	
	@GetMapping("/")
	public ModelAndView terms(ModelAndView mav) {
		mav.setViewName("/terms/main");
		return mav;
	}

	@GetMapping("/privacy")
	public ModelAndView privacy(ModelAndView mav) {
		mav.setViewName("/terms/privacy");
		return mav;
	}
	
	@GetMapping("/service")
	public ModelAndView service(ModelAndView mav) {
		mav.setViewName("/terms/service");
		return mav;
	}
}
