package nl.tomvanzummeren.msnapi.messenger.json.events.messages;

import nl.tomvanzummeren.msnapi.messenger.json.MsnContactJson;
import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;
import nl.tomvanzummeren.msnapi.messenger.service.events.UserIsTypingEvent;

/**
 * @author Tom van Zummeren
 */
public class UserIsTypingEventJson implements MsnEventJson {

    private MsnContactJson contact;

    public UserIsTypingEventJson(UserIsTypingEvent event) {
        contact = new MsnContactJson(event.getContact());
    }

    @Override
    public String getType() {
        return "user-typing";
    }

    public MsnContactJson getContact() {
        return contact;
    }
}
