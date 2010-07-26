package nl.tomvanzummeren.msnapi.messenger.service;

import org.springframework.util.Assert;

import java.util.HashMap;
import java.util.Map;

/**
 * Place to store and retrieve contact avatar images for a specific session.
 * 
 * @author Tom van Zummeren
 */
public class AvatarStore {

    private Map<String, byte[]> contactIdToImageData;

    public AvatarStore() {
        contactIdToImageData = new HashMap<String, byte[]>();
    }

    public void storeAvatar(String contactId, byte[] imageData) {
        contactIdToImageData.put(contactId, imageData);
    }

    public byte[] getAvatar(String contactId) {
        byte[] imageData = contactIdToImageData.get(contactId);
        Assert.notNull(imageData, "avatar not found for contact with id: " + contactId);
        return imageData;
    }
}
