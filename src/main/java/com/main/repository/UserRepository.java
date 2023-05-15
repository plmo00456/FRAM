package com.main.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.main.vo.Users;

@Repository
public interface UserRepository extends JpaRepository<Users, Long> {
	
	Users findById(String id);
	
	Users findByEmail(String email);
}
