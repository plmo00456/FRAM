package com.main.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.ResourceUrlEncodingFilter;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	@Value("${file.upload.dir}")
	private String fileUploadDir;
	
	@Value("${file.mapping.dir}")
	private String fileMappingDir;
	
	@Autowired
    private CommonModelAttributeInterceptor commonModelAttributeInterceptor;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler(fileMappingDir + "**")
                .addResourceLocations("file:///" + fileUploadDir);
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(commonModelAttributeInterceptor);
    }
}