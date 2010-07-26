package nl.tomvanzummeren.msnapi.common;

import net.sf.json.JSONObject;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * View for rendering any Java bean as JSON and sending it to the client using a HTTP response.
 *
 * @author Tom van Zummeren
 * @see net.sf.json.JSONObject
 */
public class JsonView implements View {

    private Object bean;

    /**
     * Constructs a new {@code JsonView} able to render the given bean.
     *
     * @param bean a bean object. Cannot be a collection. Collections should be wrapped in a bean.
     */
    public JsonView(Object bean) {
        this.bean = bean;
    }

    /**
     * {@inheritDoc}
     */
    public String getContentType() {
        return "text/json";
    }

    /**
     * {@inheritDoc}
     */
    public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType(getContentType());
        response.setCharacterEncoding("UTF-8");

        JSONObject jsonObject = JSONObject.fromObject(bean);
        response.getWriter().print(jsonObject);
    }
}
