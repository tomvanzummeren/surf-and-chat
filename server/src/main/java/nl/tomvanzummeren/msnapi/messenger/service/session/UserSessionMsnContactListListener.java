package nl.tomvanzummeren.msnapi.messenger.service.session;

import net.sf.jml.MsnContact;
import net.sf.jml.MsnContactList;
import net.sf.jml.MsnMessenger;
import net.sf.jml.event.MsnContactListAdapter;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactListEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactUpdatedEvent;

/**
 * @author Tom van Zummeren
 */
public class UserSessionMsnContactListListener extends MsnContactListAdapter {
    
    private final UserSession userSession;

    public UserSessionMsnContactListListener(UserSession userSession) {
        this.userSession = userSession;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void contactListInitCompleted(MsnMessenger messenger) {
        MsnContactList contactList = messenger.getContactList();
        userSession.queueEvent(new ContactListEvent(contactList));
    }

    @Override
    public void contactStatusChanged(MsnMessenger msnMessenger, MsnContact msnContact) {
        userSession.queueEvent(new ContactUpdatedEvent(msnContact));
    }

    @Override
    public void contactPersonalMessageChanged(MsnMessenger msnMessenger, MsnContact msnContact) {
        userSession.queueEvent(new ContactUpdatedEvent(msnContact));
    }
}
