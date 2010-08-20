package nl.tomvanzummeren.msnapi.messenger.service;

import net.sf.jml.DisplayPictureListener;
import net.sf.jml.Email;
import net.sf.jml.MsnContactList;
import net.sf.jml.MsnMessenger;
import net.sf.jml.MsnObject;
import net.sf.jml.MsnOwner;
import net.sf.jml.MsnProtocol;
import net.sf.jml.MsnUserStatus;
import net.sf.jml.event.MsnMessengerAdapter;
import net.sf.jml.impl.MsnMessengerFactory;
import net.sf.jml.message.p2p.DisplayPictureRetrieveWorker;
import nl.tomvanzummeren.msnapi.messenger.service.events.MsnEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.AvatarReceivedEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactListEvent;
import nl.tomvanzummeren.msnapi.messenger.service.session.UserSession;
import nl.tomvanzummeren.msnapi.messenger.service.session.UserSessionMsnContactListListener;
import nl.tomvanzummeren.msnapi.messenger.service.session.UserSessionMsnMessageListener;
import nl.tomvanzummeren.msnapi.messenger.service.session.UserSessionMsnMessengerListener;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Tom van Zummeren
 */
@Service
public class MessengerService implements DisposableBean {

    private static Logger log = LogManager.getLogger(MessengerService.class);

    private static final MsnProtocol DEFAULT_MSN_PROTOCOL = MsnProtocol.MSNP15;

    private Map<String, UserSession> userSessions;

    public MessengerService() {
        userSessions = new HashMap<String, UserSession>();
    }

    public void login(LoginForm loginForm, final String sessionId) {
        UserSession existingUserSession = userSessions.get(sessionId);
        if (existingUserSession != null) {
            existingUserSession.getMessenger().logout();
        }

        MsnMessenger messenger = MsnMessengerFactory.createMsnMessenger(loginForm.getEmail(), loginForm.getPassword());
        messenger.setSupportedProtocol(new MsnProtocol[] {DEFAULT_MSN_PROTOCOL});

        MsnOwner owner = messenger.getOwner();
        owner.setInitStatus(MsnUserStatus.ONLINE);
        if (loginForm.getDisplayName() != null) {
            owner.setInitDisplayName(loginForm.getDisplayName());
        }
        if (loginForm.getPersonalMessage() != null) {
            owner.setInitPersonalMessage(loginForm.getPersonalMessage());
        }

        UserSession userSession = new UserSession(messenger);
        userSessions.put(sessionId, userSession);
        log.info("Added session: " + sessionId);

        messenger.addMessengerListener(new MsnMessengerAdapter() {
            @Override
            public void logout(MsnMessenger messenger) {
                userSessions.remove(sessionId);
                log.info("Removed session: " + sessionId);
            }
        });
        messenger.addMessageListener(new UserSessionMsnMessageListener(userSession));
        messenger.addMessengerListener(new UserSessionMsnMessengerListener(userSession));
        messenger.addContactListListener(new UserSessionMsnContactListListener(userSession));

        messenger.login();
    }

    public List<MsnEvent> waitForEvent(String sessionId) {
        UserSession userSession = resolveUserSession(sessionId);

        return userSession.takeEvents();
    }

    public void sendInstantMessage(String emailAddress, String text, String sessionId) {
        UserSession userSession = resolveUserSession(sessionId);
        MsnMessenger messenger = userSession.getMessenger();

        Email email = Email.parseStr(emailAddress);
        messenger.sendText(email, text);
    }

    public void logout(String sessionId) {
        resolveUserSession(sessionId).getMessenger().logout();
        userSessions.remove(sessionId);
        log.info("Removed session: " + sessionId);
    }

    public void changeProfile(String displayName, String personalMessage, String sessionId) {
        UserSession userSession = resolveUserSession(sessionId);
        MsnMessenger messenger = userSession.getMessenger();

        MsnOwner owner = messenger.getOwner();
        owner.setDisplayName(displayName);
        owner.setPersonalMessage(personalMessage);
    }

    public void requestContactAvatar(final String contactId, String sessionId) {
        final UserSession userSession = resolveUserSession(sessionId);

        final MsnObject avatar = userSession.findAvatarByContactId(contactId);
        
        MsnMessenger messenger = userSession.getMessenger();
        messenger.retrieveDisplayPicture(avatar, new DisplayPictureListener() {
            public void notifyMsnObjectRetrieval(MsnMessenger messenger, DisplayPictureRetrieveWorker worker, MsnObject msnObject, ResultStatus result, byte[] resultBytes, Object context) {
                if (result != ResultStatus.GOOD) {
                    log.error("Failed to retrieve avatar for contact with id: " + contactId);
                    return;
                }
                // Store the avatar in the avatar store so it can be downloaded by the client later
                userSession.getAvatarStore().storeAvatar(contactId, resultBytes);
                // Send an event notifying that the avatar is available for download
                userSession.queueEvent(new AvatarReceivedEvent(contactId));
            }
        });
    }

    public byte[] getContactAvatar(String contactId, String sessionId) {
        UserSession userSession = resolveUserSession(sessionId);
        return userSession.getAvatarStore().getAvatar(contactId);
    }

    public boolean sendContactListIfLoggedIn(String sessionId) {
        UserSession userSession = userSessions.get(sessionId);
        if (userSession != null) {
            MsnContactList contactList = userSession.getMessenger().getContactList();
            userSession.cancelCurrentEventTaker();
            userSession.queueEvent(new ContactListEvent(contactList));
            return true;
        }
        else return false;
    }

    public void stopWaitingForEvent(String sessionId) {
        UserSession userSession = userSessions.get(sessionId);
        userSession.cancelCurrentEventTaker();
    }

    public void requestContactList(String sessionId) {
        UserSession userSession = resolveUserSession(sessionId);
        MsnContactList contactList = userSession.getMessenger().getContactList();
        userSession.queueEvent(new ContactListEvent(contactList));
    }

    public void destroyUserSession(String sessionId) {
        UserSession userSession = userSessions.get(sessionId);
        if(userSession != null) {
            userSession.getMessenger().logout();
            userSessions.remove(sessionId);
            log.info("Removed session: " + sessionId);
        }
    }

    /**
     * {@inheritDoc}
     */
    public void destroy() throws Exception {
        for (Map.Entry<String, UserSession> entry : userSessions.entrySet()) {
            UserSession userSession = entry.getValue();
            userSession.getMessenger().logout();
        }
    }

    /**
     * Resolves the user session by http session id.
     *
     * @param sessionId http session id
     * @return resolved user session
     * @throws IllegalStateException when there is no such session
     */
    private UserSession resolveUserSession(String sessionId) throws IllegalStateException {
        UserSession userSession = userSessions.get(sessionId);
        if (userSession == null) {
            log.error("Session not found: " + sessionId);
            throw new IllegalStateException("Not logged in");
        }
        return userSession;
    }

    public List<ActiveSession> listActiveSessions() {
        List<ActiveSession> activeSessions = new ArrayList<ActiveSession>();
        for (Map.Entry<String, UserSession> entry : userSessions.entrySet()) {
            String sessionId = entry.getKey();
            UserSession userSession = entry.getValue();
            MsnOwner owner = userSession.getMessenger().getOwner();
            
            activeSessions.add(new ActiveSession(sessionId, owner.getEmail().toString(), userSession.getCreatedAt()));
        }
        return activeSessions;
    }
}
