package com.main.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.main.repository.MenuRepository;
import com.main.vo.Menu;

@Service
public class MenuService {

    @Autowired
    private MenuRepository menuRepository;

    public List<Menu> getMenus(){
    	return menuRepository.findAllByOrderByOrderAsc();
    }
    
}