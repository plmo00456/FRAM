package com.main.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.main.vo.FileMaster;

@Repository
public interface FileMasterRepository extends JpaRepository<FileMaster, Long> {
	
}