package com.main.service;

import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.main.JwtUtil.JwtToken;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.repository.UserRepository;
import com.main.vo.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsersService {
	
	private final BCryptPasswordEncoder passwordEncoder;
    private final UserRepository repository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    private UserRepository userRepository;

    public Users createUser(Users user) {
        return userRepository.save(user);
    }

    public Optional<Users> getUser(Long seq) {
        return userRepository.findById(seq);
    }

    public List<Users> getAllUsers() {
        return userRepository.findAll();
    }

    public Users updateUser(Long seq, String name, String email) {
        Users user = userRepository.findById(seq).orElseThrow(() -> new RuntimeException("User not found"));
        user.setName(name);
        user.setEmail(email);
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
    
    public JwtToken login(String id, String password, HttpServletResponse res) {
    	Users user = userRepository.findById(id);
        if (user == null) {
        	System.out.println(id);
            throw new UsernameNotFoundException("User not found with id: " + id);
        }
        if (!passwordEncoder.matches(password, user.getPassword())) {
        	System.out.println(password);
            throw new BadCredentialsException("Invalid password");
        }
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(id, password);
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        JwtToken token = jwtTokenProvider.generateToken(authentication, res);
        
        return token;
    }
    
    public JwtToken emailLogin(String email, String password, HttpServletResponse res) {
    	Users user = userRepository.findByEmail(email);
        if (user == null) {
        	System.out.println(email);
            throw new UsernameNotFoundException("User not found with email: " + email);
        }
        if (!passwordEncoder.matches(password, user.getPassword())) {
        	System.out.println(passwordEncoder.encode(password));
            throw new BadCredentialsException("Invalid password");
        }
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(email, password);
        System.out.println(email);
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        JwtToken token = jwtTokenProvider.generateToken(authentication, res);
        
        return token;
    }
}