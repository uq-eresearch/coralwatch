package org.coralwatch.portlets;

import au.edu.uq.itee.maenad.util.BCrypt;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class LoginPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(LoginPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("login-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();

    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("userPageUrl", prefs.getValue("userPageUrl", "user"));
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession(true);
        List<String> errors = new ArrayList<String>();
        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        if (cmd.equals(Constants.DEACTIVATE)) {
            session.removeAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
        } else {
            String email = actionRequest.getParameter("signinEmail");
            //TODO validate the email here
            UserImpl currentUser;
            if (email == null || email.isEmpty()) {
                errors.add("Enter a valid email address.");
            } else {
                currentUser = userdao.getByEmail(email);
                if (currentUser == null) {
                    errors.add("Enter valid sign in details.");
                } else {
                    String password = actionRequest.getParameter("signinPassword");
                    if (password == null || password.isEmpty() || !BCrypt.checkpw(password, currentUser.getPasswordHash())) {
                        errors.add("Enter a valid password.");
                    } else {
                        session.setAttribute("currentUser", currentUser, PortletSession.APPLICATION_SCOPE);
                    }
                }
            }
            actionRequest.setAttribute("errors", errors);
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