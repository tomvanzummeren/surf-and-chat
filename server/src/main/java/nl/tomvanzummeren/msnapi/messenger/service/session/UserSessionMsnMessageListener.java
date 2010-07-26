package nl.tomvanzummeren.msnapi.messenger.service.session;

import net.sf.jml.MsnContact;
import net.sf.jml.MsnSwitchboard;
import net.sf.jml.event.MsnMessageAdapter;
import net.sf.jml.message.MsnControlMessage;
import net.sf.jml.message.MsnInstantMessage;
import nl.tomvanzummeren.msnapi.messenger.service.events.InstantMessageEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.UserIsTypingEvent;

/**
 * Listens to messages received from the MSN server and responds to them by adding these messages as events to a
 * {@link UserSession}.
 *
 * @author Tom van Zummeren
 */
public class UserSessionMsnMessageListener extends MsnMessageAdapter {

    private final UserSession userSession;

    /**
     * Constructs a new <code>UserSessionMsnMessageListener</code> using a user session.
     *
     * @param userSession to pass received messages
     */
    public UserSessionMsnMessageListener(UserSession userSession) {
        this.userSession = userSession;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void instantMessageReceived(MsnSwitchboard switchboard, MsnInstantMessage message, MsnContact contact) {
        userSession.queueEvent(new InstantMessageEvent(message, contact));
    }

    @Override
    public void controlMessageReceived(MsnSwitchboard msnSwitchboard, MsnControlMessage msnControlMessage, MsnContact msnContact) {
        userSession.queueEvent(new UserIsTypingEvent(msnContact));
    }
    
}
