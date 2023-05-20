package com.main.JwtUtil;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Builder
@Data
@AllArgsConstructor
public class JwtToken {
	
	public void JwtToken(String grantType, String accessToken, String refreshToken, Integer accessExpire) {
		this.grantType = grantType;
		this.accessToken = accessToken;
		this.refreshToken = refreshToken;
		this.accessExpire = accessExpire;
	}
 
    private String grantType;
    private String accessToken;
    private String refreshToken;
    private Integer accessExpire;
}