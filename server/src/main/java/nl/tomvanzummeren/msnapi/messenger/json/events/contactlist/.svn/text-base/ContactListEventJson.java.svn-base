package nl.tomvanzummeren.msnapi.messenger.json.events.contactlist;

import net.sf.jml.MsnContact;
import net.sf.jml.MsnContactList;
import net.sf.jml.MsnGroup;
import net.sf.json.JSONArray;
import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;
import nl.tomvanzummeren.msnapi.messenger.json.MsnGroupJson;
import nl.tomvanzummeren.msnapi.messenger.service.events.contactlist.ContactListEvent;

import java.util.*;

/**
 * @author Tom van Zummeren
 */
public class ContactListEventJson implements MsnEventJson {

    private static final String DEFAULT_GROUP_ID = "0";

    private JSONArray groups;

    public ContactListEventJson(ContactListEvent contactListEvent) {
        MsnContactList contactList = contactListEvent.getContactList();
        groups = new JSONArray();

        Set<MsnContact> contactsInGroups = new HashSet<MsnContact>();
        for (MsnGroup msnGroup : contactList.getGroups()) {
            if (!DEFAULT_GROUP_ID.equals(msnGroup.getGroupId())) {
                groups.add(new MsnGroupJson(msnGroup));
                contactsInGroups.addAll(Arrays.asList(msnGroup.getContacts()));
            }
        }

        // Add remaining contacts to "Other Contacts" group
        MsnContact[] allContacts = contactList.getContacts();
        List<MsnContact> otherContacts = new ArrayList<MsnContact>();
        for (MsnContact contact : allContacts) {
            if (!contactsInGroups.contains(contact)) {
                otherContacts.add(contact);
            }
        }
        groups.add(new MsnGroupJson(DEFAULT_GROUP_ID, "Other Contacts", otherContacts));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getType() {
        return "contact-list";
    }

    public JSONArray getGroups() {
        return groups;
    }
}
