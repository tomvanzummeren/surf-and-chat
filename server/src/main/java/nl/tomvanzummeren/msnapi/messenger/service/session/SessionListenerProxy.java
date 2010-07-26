package nl.tomvanzummeren.msnapi.messenger.service.session;

import org.springframework.context.ApplicationContext;
import org.springframework.util.Assert;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Map;

import static org.springframework.web.context.support.WebApplicationContextUtils.getWebApplicationContext;

/**
 * Proxies calls to an instance in the web application context.
 *
 * @author Tom van Zummeren
 */
public class SessionListenerProxy implements HttpSessionListener {

    private HttpSessionListener listener;

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        getDelegate(se).sessionCreated(se);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        getDelegate(se).sessionDestroyed(se);
    }

    private HttpSessionListener getDelegate(HttpSessionEvent se) {
        if (listener != null) {
            return listener;
        }
        ServletContext servletContext = se.getSession().getServletContext();
        ApplicationContext context = getWebApplicationContext(servletContext);

        Map<String, HttpSessionListener> listeners = context.getBeansOfType(HttpSessionListener.class);
        Assert.isTrue(listeners.size() == 1, "Expected exactly one HttpSessionListener in the application context");

        listener = listeners.values().iterator().next();
        return listener;
    }
}
