package nl.tomvanzummeren.msnapi.messenger.json.events.login;

import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;

/**
 * @author Tom van Zummeren
 */
public class LoginFailedEventJson implements MsnEventJson {
    
    public String getType() {
        return "login-failed";
    }
}
