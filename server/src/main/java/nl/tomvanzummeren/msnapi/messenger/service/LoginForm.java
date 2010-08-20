package nl.tomvanzummeren.msnapi.messenger.service;

import static org.springframework.util.StringUtils.*;

/**
 * @author Tom van Zummeren
 */
public class LoginForm {

    private String email;

    private String password;

    private String displayName;

    private String personalMessage;

    public LoginForm() {
    }

    public boolean isValid() {
        return hasText(email) && hasText(password);
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getPersonalMessage() {
        return personalMessage;
    }

    public void setPersonalMessage(String personalMessage) {
        this.personalMessage = personalMessage;
    }
}
