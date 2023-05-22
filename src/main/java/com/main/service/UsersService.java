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

import com.google.gson.JsonObject;
import com.main.JwtUtil.JwtToken;
import com.main.JwtUtil.JwtTokenProvider;
import com.main.repository.UserRepository;
import com.main.utils.Utils;
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
            throw new UsernameNotFoundException("User not found with id: " + id);
        }
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new BadCredentialsException("Invalid password");
        }
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(id, password);
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        JwtToken token = jwtTokenProvider.generateToken(authentication, res);
        
        return token;
    }
    
    public JwtToken register(String id, String password, String name, HttpServletResponse res) {
    	Utils utils = new Utils();
    	
    	Users user = userRepository.findById(id);
        if (user != null) {
        	JsonObject result = new JsonObject();
        	result.addProperty("status", "N");
        	result.addProperty("msg", "이미 사용중인 아이디 입니다.");
        	utils.sendJsonResponse(res, result);
        	return null;
        }
        
        user = new Users();
        user.setId(id);
        user.setPassword(passwordEncoder.encode(password));
        user.setName(name);
        user.setNickname(name);
        
        createUser(user);
        
        user = userRepository.findById(id);
        if (user == null) {
        	JsonObject result = new JsonObject();
        	result.addProperty("status", "N");
        	result.addProperty("msg", "회원가입 중 오류가 발생했습니다.<br>관리자에게 문의해주세요");
        	utils.sendJsonResponse(res, result);
        	return null;
        }else {
        	UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(id, password);
            Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
            JwtToken token = jwtTokenProvider.generateToken(authentication, res);        	
        	return token;
        }
    }
    
    public JwtToken emailLogin(Users userEntity, HttpServletResponse res) {
    	String password = userEntity.getPassword();
    	String encPassword = passwordEncoder.encode(password);
    	Users user = userRepository.findByEmailAndProvide(userEntity.getEmail(), userEntity.getProvide());
        if (user == null) {
        	userEntity.setPassword(encPassword);
        	createUser(userEntity);
        	user = userRepository.findByEmailAndProvide(userEntity.getEmail(), userEntity.getProvide());
            //throw new UsernameNotFoundException("User not found with email: " + email);
        }
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(user.getEmail() + "‡" + user.getProvide(), password);
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        JwtToken token = jwtTokenProvider.generateToken(authentication, res);
        
        return token;
    }
}