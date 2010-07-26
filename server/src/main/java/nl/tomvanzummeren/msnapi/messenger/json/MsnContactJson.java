package nl.tomvanzummeren.msnapi.messenger.json;

import net.sf.jml.MsnContact;

/**
 * Json representation of an {@code MsnContact}. When rendered using {@code JSONObject} the output looks like this:
 * <pre>
 * {
 *   "name": "Example user"
 *   "email": "example@domain.com"
 *   "status": "Online"
 * }
 * </pre>
 *
 * @author Tom van Zummeren
 * @see net.sf.jml.MsnContact
 * @see net.sf.json.JSONObject
 */
public class MsnContactJson {

    private String id;

    private String email;

    private String name;

    private String personalMessage;

    private String status;

    /**
     * Creates a new {@code MsnContactJson} based on a {@code MsnContact}.
     *
     * @param msnContact to base this json message on
     */
    public MsnContactJson(MsnContact msnContact) {
        id = msnContact.getId();
        email = msnContact.getEmail().getEmailAddress();
        name = msnContact.getDisplayName();
        personalMessage = msnContact.getPersonalMessage();
        status = msnContact.getStatus().getDisplayStatus();
    }

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

    public String getPersonalMessage() {
        return personalMessage;
    }

    public String getStatus() {
        return status;
    }
}
