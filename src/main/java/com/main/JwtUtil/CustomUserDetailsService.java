package com.main.JwtUtil;

import java.util.ArrayList;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.main.repository.UserRepository;
import com.main.vo.Users;

import java.util.List;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
 
	private final UserRepository userRepository;
	
    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
    	Users user = userRepository.findById(id);
    	if(user == null)
    		user = userRepository.findByEmail(id);
    	
    	if(user == null) throw new UsernameNotFoundException("User not found with id: " + id);

        List<GrantedAuthority> listAuthorities = new ArrayList<GrantedAuthority>();
        listAuthorities.add(new SimpleGrantedAuthority("ROLE_USER"));
    	return new CustomUserDetails(user, listAuthorities);
    }
}