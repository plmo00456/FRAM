package com.main.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.main.vo.Comment;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
	List<Comment> findByPlaceId(Integer placeId);
	
	List<Comment> findByPlaceIdAndUserSeqIsNotNullAndUseYn(Integer placeId, String useYn);
}
