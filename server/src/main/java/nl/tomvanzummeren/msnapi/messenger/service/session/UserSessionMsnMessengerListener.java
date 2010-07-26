package nl.tomvanzummeren.msnapi.messenger.service.session;

import net.sf.jml.MsnMessenger;
import net.sf.jml.event.MsnMessengerAdapter;
import net.sf.jml.exception.LoginException;
import nl.tomvanzummeren.msnapi.messenger.service.events.LoginFailedEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.LoginSuccessEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.LogoutEvent;

/**
 * Listens to general MSN messenger events (like logging in and out) and responds to them by adding these events to a
 * {@link UserSession}.
 *
 * @author Tom van Zummeren
 */
public class UserSessionMsnMessengerListener extends MsnMessengerAdapter {

    private UserSession userSession;

    public UserSessionMsnMessengerListener(UserSession userSession) {
        this.userSession = userSession;
    }

    @Override
    public void exceptionCaught(MsnMessenger messenger, Throwable throwable) {
        if (throwable instanceof LoginException) {
            userSession.queueEvent(new LoginFailedEvent());
        }
    }

    @Override
    public void loginCompleted(MsnMessenger messenger) {
        userSession.queueEvent(new LoginSuccessEvent());
    }

    @Override
    public void logout(MsnMessenger messenger) {
        userSession.queueEvent(new LogoutEvent());
    }
}
