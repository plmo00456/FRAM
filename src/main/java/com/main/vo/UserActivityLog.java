package com.main.vo;

import java.sql.Timestamp;
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
@Table(name = "user_activity_log")
public class UserActivityLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @Column(name = "user_seq")
    private Long userSeq;

    @Column(name = "user_ip", nullable = false)
    private String userIp;
    
    @Column(name = "url")
    private String url;

    @Column(name = "activity_type", nullable = false)
    private String activityType;

    @Column(name = "activity_data")
    private String activityData;

    @Column(name = "user_agent")
    private String userAgent;
    
    @Column(name = "activity_timestamp", updatable = false, insertable = false)
    private LocalDateTime activityTimestamp;
}
