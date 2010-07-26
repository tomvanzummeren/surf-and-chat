package nl.tomvanzummeren.msnapi.messenger.service.events.contactlist;

import nl.tomvanzummeren.msnapi.messenger.service.events.MsnEvent;

/**
 * @author Tom van Zummeren
 */
public class AvatarReceivedEvent implements MsnEvent {

    private String contactId;

    public AvatarReceivedEvent(String contactId) {
        this.contactId = contactId;
    }

    public String getContactId() {
        return contactId;
    }
}
