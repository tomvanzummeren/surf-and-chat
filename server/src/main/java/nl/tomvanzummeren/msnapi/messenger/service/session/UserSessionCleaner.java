package nl.tomvanzummeren.msnapi.messenger.service.session;

import nl.tomvanzummeren.msnapi.messenger.service.MessengerService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 * Listens to destroyed HttpSessions and makes sure any related UserSessions are destroyed as well. 
 *
 * @author Tom van Zummeren
 * @see nl.tomvanzummeren.msnapi.messenger.service.session.SessionListenerProxy
 */
@Component
public class UserSessionCleaner implements HttpSessionListener {

    private static Logger log = LogManager.getLogger(UserSessionCleaner.class);

    private MessengerService messengerService;

    @Autowired
    public UserSessionCleaner(MessengerService messengerService) {
        this.messengerService = messengerService;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sessionCreated(HttpSessionEvent se) {
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        messengerService.destroyUserSession(se.getSession().getId());
    }
}
