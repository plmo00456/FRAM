package com.main.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.main.repository.CommentRepository;
import com.main.vo.Comment;

@Service
public class CommentService {

    @Autowired
    private CommentRepository commentRepository;

    public List<Comment> getComments(Integer placeId){
    	return commentRepository.findByPlaceId(placeId);
    }
}