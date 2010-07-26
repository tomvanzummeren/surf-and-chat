package nl.tomvanzummeren.msnapi.messenger.json;

import net.sf.jml.MsnContact;
import net.sf.jml.MsnGroup;
import net.sf.json.JSONArray;

import java.util.Collection;

/**
 * @author Tom van Zummeren
 */
public class MsnGroupJson {

    private String id;

    private String name;

    private JSONArray contacts;

    public MsnGroupJson(MsnGroup msnGroup) {
        id = msnGroup.getGroupId();
        name = msnGroup.getGroupName();
        contacts = new JSONArray();
        for (MsnContact msnContact : msnGroup.getContacts()) {
            contacts.add(new MsnContactJson(msnContact));
        }
    }

    public MsnGroupJson(String id, String name, Collection<MsnContact> msnContacts) {
        this.id = id;
        this.name = name;
        contacts = new JSONArray();
        for (MsnContact msnContact : msnContacts) {
            contacts.add(new MsnContactJson(msnContact));
        }
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public JSONArray getContacts() {
        return contacts;
    }
}
