package com.main.JwtUtil;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.main.vo.Users;

public class CustomUserDetails implements UserDetails {
	
	private final Users user;
	private final Collection<? extends GrantedAuthority> getAuthorities;
	
	public CustomUserDetails(Users user, Collection<? extends GrantedAuthority> getAuthorities) {
		this.user = user;
		this.getAuthorities = getAuthorities;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return user.getAuthorities();
	}

	@Override
	public String getPassword() {
		return user.getPassword();
	}

	@Override
	public String getUsername() {
		return user.getId();
	}
	
	public String getName() {
		return user.getName();
	}

	public String getNickname() {
		return user.getNickname();
	}

	public String getEmail() {
		return user.getEmail();
	}
	
	public String getStatus() {
		return user.getStatus();
	}
	
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}

}