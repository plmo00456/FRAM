package com.main.vo;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "users")
public class Users {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long seq;
	private String id;
	private String name;
	private String nickname;
	private String email;
	private String status;
	@Column(name = "create_tm", updatable = false, insertable = false)
	private LocalDateTime createTm;
	@Column(name = "update_tm", updatable = false, insertable = false)
	private LocalDateTime updateTm;
	
}
