/**
 * 코멘트 VO
 * */

package com.main.vo;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "comment")
public class Comment {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long seq;
	@Column(name = "place_id")
	private Integer placeId;
	@Column(name = "user_seq")
	private Long userSeq;
	private String comment;
	private double rating;
	@Column(name = "image_path")
	private String imagePath;
	@Column(name = "use_yn")
	private String useYn;
	@Column(name = "create_tm", updatable = false, insertable = false)
	private LocalDateTime createTm;
	@Column(name = "update_tm", updatable = false, insertable = false)
	private LocalDateTime updateTm;
	
	@ManyToOne
    @JoinColumn(name = "user_seq", referencedColumnName = "seq", insertable = false, updatable = false)
    private Users user;
	
}
