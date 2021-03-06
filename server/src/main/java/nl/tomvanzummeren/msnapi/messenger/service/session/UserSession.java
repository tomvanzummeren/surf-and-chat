package nl.tomvanzummeren.msnapi.messenger.service.session;

import net.sf.jml.MsnContact;
import net.sf.jml.MsnContactList;
import net.sf.jml.MsnMessenger;
import net.sf.jml.MsnObject;
import nl.tomvanzummeren.msnapi.messenger.service.AvatarStore;
import nl.tomvanzummeren.msnapi.messenger.service.events.MsnEvent;
import org.springframework.util.Assert;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * @author Tom van Zummeren
 */
public class UserSession {

    private static final int MAXIMUM_QUEUE_SIZE = 1000;

    private MsnMessenger messenger;

    private BlockingQueue<MsnEvent> incomingEvents;

    private Thread currentEventTakerThread;

    private AvatarStore avatarStore;

    private Date createdAt;

    public UserSession(MsnMessenger messenger) {
        this.messenger = messenger;
        this.incomingEvents = new ArrayBlockingQueue<MsnEvent>(MAXIMUM_QUEUE_SIZE);

        avatarStore = new AvatarStore();
        createdAt = new Date();
    }

    public void queueEvent(MsnEvent event) {
        incomingEvents.add(event);
    }

    public List<MsnEvent> takeEvents() {
        if (currentEventTakerThread != null) {
            currentEventTakerThread.interrupt();
        }
        EventQueueTaker eventQueueTaker = new EventQueueTaker(incomingEvents);
        currentEventTakerThread = new Thread(eventQueueTaker);
        currentEventTakerThread.start();
        try {
            currentEventTakerThread.join();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return eventQueueTaker.getTakenEvents();
    }

    public void cancelCurrentEventTaker() {
        if (currentEventTakerThread == null) {
            return;
        }
        currentEventTakerThread.interrupt();
        try {
            currentEventTakerThread.join();
        } catch (InterruptedException e) {
            // Do nothing
        }
    }

    public MsnMessenger getMessenger() {
        return messenger;
    }

    public AvatarStore getAvatarStore() {
        return avatarStore;
    }

    public MsnObject findAvatarByContactId(String contactId) {
        MsnContactList contactList = messenger.getContactList();
        MsnContact contact = contactList.getContactById(contactId);
        Assert.notNull(contact, "Contact not found having id: " + contactId);

        MsnObject avatar = contact.getAvatar();
        Assert.isTrue(avatar.getType() == MsnObject.TYPE_DISPLAY_PICTURE, "Avatar not of type display picture");
        return avatar;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    private static class EventQueueTaker implements Runnable {

        private BlockingQueue<MsnEvent> eventQueue;

        private List<MsnEvent> takenEvents;

        private EventQueueTaker(BlockingQueue<MsnEvent> eventQueue) {
            this.eventQueue = eventQueue;
            takenEvents = new ArrayList<MsnEvent>();
        }

        @Override
        public void run() {
            try {
                MsnEvent event = eventQueue.take();

                takenEvents = new ArrayList<MsnEvent>();
                takenEvents.add(event);
                takeAnyRemainingEventsFromQueue(takenEvents);
            } catch (InterruptedException e) {
                // Let this thread die
            }
        }

        private void takeAnyRemainingEventsFromQueue(List<MsnEvent> events) {
            for (int i = 0; i < eventQueue.size(); i++) {
                MsnEvent event = eventQueue.poll();
                if (event != null) {
                    events.add(event);
                }
            }
        }

        public List<MsnEvent> getTakenEvents() {
            return takenEvents;
        }
    }
}
