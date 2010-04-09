package org.coralwatch.portlets;

import au.edu.uq.itee.maenad.util.BCrypt;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.portlets.error.SubmissionError;

import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class LoginPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(JSPPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;
    protected List<SubmissionError> errors;

    public void init() throws PortletException {
        viewJSP = getInitParameter("login-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
        errors = new ArrayList<SubmissionError>();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        PortletSession session = renderRequest.getPortletSession();
        session.setAttribute("errors", errors, PortletSession.PORTLET_SCOPE);
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession(true);
        ((List<SubmissionError>) session.getAttribute("errors")).clear();
        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        if (cmd.equals(Constants.DEACTIVATE)) {
            session.removeAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
        } else {
            String email = actionRequest.getParameter("email");
            //TODO validate the email here
            UserImpl currentUser;
            if (email == null || email.isEmpty()) {
                errors.add(new SubmissionError("Enter a valid email address."));
            } else {
                currentUser = userdao.getByEmail(email);
                if (currentUser == null) {
                    errors.add(new SubmissionError("Enter valid sign in details."));
                } else {
                    String password = actionRequest.getParameter("password");
                    if (password == null || password.isEmpty() || !BCrypt.checkpw(password, currentUser.getPasswordHash())) {
                        errors.add(new SubmissionError("Enter a valid password."));
                    } else {
                        session.setAttribute("currentUser", currentUser, PortletSession.APPLICATION_SCOPE);
                    }
                }
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