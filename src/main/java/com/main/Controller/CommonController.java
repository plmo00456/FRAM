package com.main.Controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.main.service.MenuService;

@Controller
public class CommonController {
	
	@Autowired
	private MenuService ms;
	
	@GetMapping("/common/files")
	public ModelAndView files(ModelAndView mav) {
		
		mav.setViewName("common/files");
		return mav;
	}

	@GetMapping("/common/top")
	public ModelAndView Top(ModelAndView mav, HttpServletRequest req) {
		mav.addObject("menu", ms.getMenus());
		mav.setViewName("common/top");
		return mav;
	}
	
	@GetMapping("/common/footer")
	public ModelAndView Footer(ModelAndView mav) {
		
		mav.setViewName("common/footer");
		return mav;
	}
}
