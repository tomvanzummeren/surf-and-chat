package nl.tomvanzummeren.msnapi.messenger.service;

import java.util.Date;

/**
 * @author Tom van Zummeren
 */
public class ActiveSession {

    private String sessionId;

    private String email;

    private Date onlineSince;

    public ActiveSession(String sessionId, String email, Date onlineSince) {
        this.sessionId = sessionId;
        this.email = email;
        this.onlineSince = onlineSince;
    }

    public String getSessionId() {
        return sessionId;
    }

    public String getEmail() {
        return email;
    }

    public Date getOnlineSince() {
        return onlineSince;
    }
}
