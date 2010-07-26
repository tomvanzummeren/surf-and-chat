package nl.tomvanzummeren.msnapi.messenger.service.events;

import net.sf.jml.MsnContact;
import net.sf.jml.message.MsnInstantMessage;

/**
 * @author Tom van Zummeren
 */
public class InstantMessageEvent implements MsnEvent {

    private MsnInstantMessage message;

    private MsnContact contact;

    public InstantMessageEvent(MsnInstantMessage message, MsnContact contact) {
        this.message = message;
        this.contact = contact;
    }

    public MsnInstantMessage getMessage() {
        return message;
    }

    public MsnContact getContact() {
        return contact;
    }
}
