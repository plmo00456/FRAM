package com.main.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.main.vo.Comment;
import com.main.vo.UsersLocation;

@Repository
public interface UsersLocationRepository extends JpaRepository<UsersLocation, Long> {
}
