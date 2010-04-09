package org.coralwatch.portlets;

import au.edu.uq.itee.maenad.util.BCrypt;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;

import javax.portlet.*;
import java.io.IOException;


public class LoginPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(JSPPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("login-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession(true);
        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        if (cmd.equals(Constants.DEACTIVATE)) {
            session.removeAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
        } else {
            String email = actionRequest.getParameter("email");
            String password = actionRequest.getParameter("password");

            UserImpl currentUser = userdao.getByEmail(email);
            if (currentUser != null && BCrypt.checkpw(password, currentUser.getPasswordHash())) {
                session.setAttribute("currentUser", currentUser, PortletSession.APPLICATION_SCOPE);
            } else {
                _log.error("No user with email address: " + email);
            }
        }
    }

    protected void include(String path, RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

        PortletRequestDispatcher portletRequestDispatcher = getPortletContext().getRequestDispatcher(path);

        if (portletRequestDispatcher == null) {
            _log.error(path + " is not a valid include");
        } else {
            portletRequestDispatcher.include(renderRequest, renderResponse);
        }
    }
}