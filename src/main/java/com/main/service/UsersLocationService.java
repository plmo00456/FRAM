package com.main.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.main.repository.UsersLocationRepository;
import com.main.vo.UsersLocation;

@Service
public class UsersLocationService {

    @Autowired
    private UsersLocationRepository usersLocationRepository;
    
    public UsersLocation insertUpdateUserLocation(Long seq, String lat, String lon) {
    	UsersLocation ul = new UsersLocation(seq, lat, lon);
        return usersLocationRepository.save(ul);
    }
}