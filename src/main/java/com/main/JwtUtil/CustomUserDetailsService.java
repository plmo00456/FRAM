package com.main.JwtUtil;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.main.repository.UserRepository;
import com.main.vo.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
 
	private final UserRepository userRepository;
 
    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
    	Users user = userRepository.findById(id);
    	if(user == null) throw new UsernameNotFoundException("User not found with id: " + id);
    	
        return createUserDetails(user);
    }
 
    // 해당하는 User 의 데이터가 존재한다면 UserDetails 객체로 만들어서 리턴
    private UserDetails createUserDetails(Users users) {
        return User.builder()
                .username(users.getId())
                .password(users.getPassword())
                .roles(users.getRoles().toArray(new String[0]))
                .build();
    }
}