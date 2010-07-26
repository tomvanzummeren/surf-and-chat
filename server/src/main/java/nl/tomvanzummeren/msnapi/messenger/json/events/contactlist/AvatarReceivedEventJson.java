package nl.tomvanzummeren.msnapi.messenger.json.events.contactlist;

import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.AvatarReceivedEvent;

/**
 * @author Tom van Zummeren
 */
public class AvatarReceivedEventJson implements MsnEventJson {

    private String contactId;

    public AvatarReceivedEventJson(AvatarReceivedEvent avatarReceivedEvent) {
        contactId = avatarReceivedEvent.getContactId();
    }

    @Override
    public String getType() {
        return "avatar-received";
    }

    public String getContactId() {
        return contactId;
    }
}
