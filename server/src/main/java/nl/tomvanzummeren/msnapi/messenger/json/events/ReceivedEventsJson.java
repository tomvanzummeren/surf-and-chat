package nl.tomvanzummeren.msnapi.messenger.json.events;

import net.sf.json.JSONArray;
import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.contactlist.AvatarReceivedEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.contactlist.ContactListEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.contactlist.ContactUpdatedEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.login.LoginFailedEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.login.LoginSuccessEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.login.LogoutEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.messages.InstantMessageJson;
import nl.tomvanzummeren.msnapi.messenger.json.events.messages.UserIsTypingEventJson;
import nl.tomvanzummeren.msnapi.messenger.service.events.InstantMessageEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.LoginFailedEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.LoginSuccessEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.LogoutEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.MsnEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.UserIsTypingEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.AvatarReceivedEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactListEvent;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactUpdatedEvent;

import java.util.List;

/**
 * @author Tom van Zummeren
 */
public class ReceivedEventsJson {

    private JSONArray events;

    public ReceivedEventsJson(List<MsnEvent> msnEvents) {
        events = new JSONArray();
        for (MsnEvent msnEvent : msnEvents) {
            MsnEventJson eventJson;
            if (msnEvent instanceof InstantMessageEvent) {
                eventJson = new InstantMessageJson((InstantMessageEvent) msnEvent);
            } else if (msnEvent instanceof LoginSuccessEvent) {
                eventJson = new LoginSuccessEventJson();
            } else if (msnEvent instanceof LoginFailedEvent) {
                eventJson = new LoginFailedEventJson();
            } else if (msnEvent instanceof ContactListEvent) {
                eventJson = new ContactListEventJson((ContactListEvent) msnEvent);
            } else if (msnEvent instanceof ContactUpdatedEvent) {
                eventJson = new ContactUpdatedEventJson((ContactUpdatedEvent) msnEvent);
            } else if (msnEvent instanceof AvatarReceivedEvent) {
                eventJson = new AvatarReceivedEventJson((AvatarReceivedEvent) msnEvent);
            } else if (msnEvent instanceof UserIsTypingEvent) {
                eventJson = new UserIsTypingEventJson((UserIsTypingEvent) msnEvent);
            } else if (msnEvent instanceof LogoutEvent) {
                eventJson = new LogoutEventJson();
            } else {
                throw new IllegalArgumentException("Unknown event type: " + msnEvent.getClass().getSimpleName());
            }
            events.add(eventJson);
        }
    }

    public JSONArray getEvents() {
        return events;
    }
}
