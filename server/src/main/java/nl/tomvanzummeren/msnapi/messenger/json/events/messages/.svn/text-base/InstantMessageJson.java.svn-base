package nl.tomvanzummeren.msnapi.messenger.json.events.messages;

import nl.tomvanzummeren.msnapi.messenger.json.MsnContactJson;
import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;
import nl.tomvanzummeren.msnapi.messenger.service.events.InstantMessageEvent;

/**
 * @author Tom van Zummeren
 */
public class InstantMessageJson implements MsnEventJson {

    private MsnContactJson contact;

    private String message;

    public InstantMessageJson(InstantMessageEvent instantMessageEvent) {
        contact = new MsnContactJson(instantMessageEvent.getContact());
        message = instantMessageEvent.getMessage().getContent();
    }

    public String getType() {
        return "instant-message";
    }

    public MsnContactJson getContact() {
        return contact;
    }

    public String getMessage() {
        return message;
    }
}
