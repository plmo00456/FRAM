package com.main.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.main.repository.UserActivityLogRepository;
import com.main.vo.UserActivityLog;

@Service
public class UserActivityLogService {
    @Autowired
    private UserActivityLogRepository userActivityLogRepository;

    public void logActivity(String userIp, Long userSeq, String url, String activityType, String activityData, String userAgent) {
        UserActivityLog logEntry = new UserActivityLog();
        logEntry.setUserIp(userIp);
        logEntry.setUserSeq(userSeq);
        logEntry.setUrl(url);
        logEntry.setActivityType(activityType);
        logEntry.setActivityData(activityData);
        logEntry.setUserAgent(userAgent);
        userActivityLogRepository.save(logEntry);
    }
}
