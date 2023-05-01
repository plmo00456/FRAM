package com.main.JwtUtil;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Builder
@Data
@AllArgsConstructor
public class JwtToken {
	
	public void JwtToken(String grantType, String accessToken, String refreshToken) {
		this.grantType = grantType;
		this.accessToken = accessToken;
		this.refreshToken = refreshToken;
	}
 
    private String grantType;
    private String accessToken;
    private String refreshToken;
}