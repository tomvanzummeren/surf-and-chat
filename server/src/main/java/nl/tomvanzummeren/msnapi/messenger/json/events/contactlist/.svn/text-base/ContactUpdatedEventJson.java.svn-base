package nl.tomvanzummeren.msnapi.messenger.json.events.contactlist;

import net.sf.jml.MsnContact;
import nl.tomvanzummeren.msnapi.messenger.json.MsnContactJson;
import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactUpdatedEvent;

/**
 * @author Tom van Zummeren
 */
public class ContactUpdatedEventJson implements MsnEventJson {
    
    private MsnContactJson contact;

    public ContactUpdatedEventJson(ContactUpdatedEvent event) {
        MsnContact updatedContact = event.getUpdatedContact();
        this.contact = new MsnContactJson(updatedContact);
    }

    @Override
    public String getType() {
        return "contact-updated";
    }

    public MsnContactJson getContact() {
        return contact;
    }
}
