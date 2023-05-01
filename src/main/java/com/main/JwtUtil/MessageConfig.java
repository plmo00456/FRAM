package com.main.JwtUtil;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;

@Configuration
public class MessageConfig {
	@Bean 
	public ResourceBundleMessageSource messageSource() { 
		ResourceBundleMessageSource source = new ResourceBundleMessageSource(); 
		source.setBasenames("security_message");
		source.setDefaultEncoding("UTF-8");
		source.setCacheSeconds(5); 
		return source; 
		} 
}