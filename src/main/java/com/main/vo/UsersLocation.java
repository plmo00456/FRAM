/**
 * 코멘트 VO
 * */

package com.main.vo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "users_location")
public class UsersLocation {
	
	public UsersLocation(Long seq, String lat, String lon) {
		this.usersSeq = seq;
		this.latitude = lat;
		this.longitude = lon;
	}

	public UsersLocation() {
	}

	@Id
	@Column(name = "users_seq")
	private Long usersSeq;
	
	private String latitude;
	private String longitude;
	
}
