package org.coralwatch.portlets;

import au.edu.uq.itee.maenad.util.BCrypt;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.portlets.error.SubmissionError;

import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class RegistrationPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(JSPPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;
    protected List<SubmissionError> errors;
    protected HashMap<String, String> params;

    public void init() throws PortletException {
        viewJSP = getInitParameter("registration-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
        errors = new ArrayList<SubmissionError>();
        params = new HashMap<String, String>();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        PortletSession session = renderRequest.getPortletSession();
        session.setAttribute("errors", errors, PortletSession.PORTLET_SCOPE);
        session.setAttribute("params", params, PortletSession.PORTLET_SCOPE);
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession(true);
        ((List<SubmissionError>) session.getAttribute("errors")).clear();

        String email = actionRequest.getParameter("email");
        params.put("email", email);
        String email2 = actionRequest.getParameter("email2");
        params.put("email2", email2);
        String password = actionRequest.getParameter("password");
        String password2 = actionRequest.getParameter("password2");
        String country = actionRequest.getParameter("country");
        params.put("country", country);
        String displayName = actionRequest.getParameter("displayName");
        params.put("displayName", displayName);

        if ((email == null) || email.isEmpty() || (displayName == null) || displayName.isEmpty() || (password == null) || (country == null) || country.isEmpty()) {
            errors.add(new SubmissionError("All fields are required."));
        } else {
            //TODO validate email
            if (!email.equals(email2)) {
                errors.add(new SubmissionError("Confirm your email address."));
            } else {
                if (password.length() < 6) {
                    errors.add(new SubmissionError("Password must be at least 6 characters."));
                } else {
                    if (!password.equals(password2)) {
                        errors.add(new SubmissionError("Confirm your password."));
                    } else {
                        if (userdao.getByEmail(email) != null) {
                            errors.add(new SubmissionError("An account with the same email already exists."));
                        } else {
                            UserImpl userImpl = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
                            userImpl.setCountry(country);
                            userdao.save(userImpl);
                            session.setAttribute("currentUser", userImpl, PortletSession.APPLICATION_SCOPE);
                        }
                    }

                }
            }
        }
    }

    protected void include(String path, RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

        PortletContext portletContext = getPortletContext();
        PortletRequestDispatcher portletRequestDispatcher = portletContext.getRequestDispatcher(path);

        if (portletRequestDispatcher == null) {
            _log.error(path + " is not a valid include");
        } else {
            try {
                portletRequestDispatcher.include(renderRequest, renderResponse);
            } catch (Exception e) {
                _log.error(e, e);
                portletRequestDispatcher = portletContext.getRequestDispatcher("/error.jsp");

                if (portletRequestDispatcher == null) {
                    _log.error("/error.jsp is not a valid include");
                } else {
                    portletRequestDispatcher.include(renderRequest, renderResponse);
                }
            }
        }
    }


    public void destroy() {
        if (_log.isInfoEnabled()) {
            _log.info("Destroying portlet");
        }
    }

}
