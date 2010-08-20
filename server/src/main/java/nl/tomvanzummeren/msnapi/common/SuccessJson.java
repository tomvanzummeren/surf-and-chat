package nl.tomvanzummeren.msnapi.common;

/**
 * Default JSON response when an operation was successful, but no data has to be returned to the client.
 *
 * @author Tom van Zummeren
 */
public class SuccessJson {

    private boolean success;

    public SuccessJson() {
        success = true;
    }

    public SuccessJson(boolean success) {
        this.success = success;
    }

    public boolean isSuccess() {
        return success;
    }
}
