package nl.tomvanzummeren.msnapi.messenger.json.events.login;

import nl.tomvanzummeren.msnapi.messenger.json.MsnEventJson;

/**
 * @author Tom van Zummeren
 */
public class LogoutEventJson implements MsnEventJson {

    @Override
    public String getType() {
        return "logout";
    }
}
