package nl.tomvanzummeren.msnapi.messenger.service.events;

import net.sf.jml.MsnContact;

/**
 * @author Tom van Zummeren
 */
public class UserIsTypingEvent implements MsnEvent {

    private MsnContact contact;

    public UserIsTypingEvent(MsnContact contact) {
        this.contact = contact;
    }

    public MsnContact getContact() {
        return contact;
    }
}
