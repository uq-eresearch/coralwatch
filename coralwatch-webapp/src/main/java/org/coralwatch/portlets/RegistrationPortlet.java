package org.coralwatch.portlets;

import au.edu.uq.itee.maenad.util.BCrypt;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;

import javax.portlet.*;
import java.io.IOException;

public class RegistrationPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(JSPPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("registration-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        String email = actionRequest.getParameter("email");
        String password = actionRequest.getParameter("password");
        String password2 = actionRequest.getParameter("password2");
        String country = actionRequest.getParameter("country");
        String displayName = actionRequest.getParameter("displayName");


        if ((email == null) || email.isEmpty()) {
            actionResponse.sendRedirect("/error.jsp");
        }
        if ((displayName == null) || displayName.isEmpty()) {
            actionResponse.sendRedirect("/error.jsp");
        }
        if ((password == null) || password.length() < 6) {
            actionResponse.sendRedirect("/error.jsp");
        } else if (!password.equals(password2)) {
            actionResponse.sendRedirect("/error.jsp");
        }

        UserImpl userImpl = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
        userImpl.setCountry(country == null ? "" : country);

        userdao.save(userImpl);
        _log.error("=========Number of users now: " + userdao.getAll().size() + " users==========");
        actionResponse.sendRedirect("/user-management/registration.jsp");
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
