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
import javax.persistence.PostLoad;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.springframework.beans.factory.annotation.Value;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "file_master")
public class FileMaster {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long seq;
	@Column(name = "user_seq")
	private Long userSeq;
	@Column(name = "ori_filename")
	private String oriFilename;
	private String filepath;
	private String filename;
	@Transient
	private String fullFilename;
	@Column(name = "create_tm", updatable = false, insertable = false)
	private LocalDateTime createTm;
	@Column(name = "update_tm", updatable = false, insertable = false)
	private LocalDateTime updateTm;
}
