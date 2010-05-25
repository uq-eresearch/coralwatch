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
import java.util.HashMap;
import java.util.List;

public class UserPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(UserPortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected List<SubmissionError> errors;
    protected HashMap<String, String> params;

    public void init() throws PortletException {
        viewJSP = getInitParameter("user-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        errors = new ArrayList<SubmissionError>();
        params = new HashMap<String, String>();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        PortletSession session = renderRequest.getPortletSession();
        session.setAttribute("errors", errors, PortletSession.PORTLET_SCOPE);
        session.setAttribute("userDao", userDao, PortletSession.PORTLET_SCOPE);
        session.setAttribute("params", params, PortletSession.PORTLET_SCOPE);
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession(true);
        errors = (List<SubmissionError>) actionRequest.getAttribute("errors");
        if (!errors.isEmpty()) {
            errors.clear();
        }

        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);

        String email = actionRequest.getParameter("email");
        String email2 = actionRequest.getParameter("email2");
        String password = actionRequest.getParameter("password");
        String password2 = actionRequest.getParameter("password2");
        String country = actionRequest.getParameter("country");
        String displayName = actionRequest.getParameter("displayName");
        String address = actionRequest.getParameter("address");
        long userId = ParamUtil.getLong(actionRequest, "userId");

        params.put("email", email);
        params.put("email2", email2);
        params.put("password", password);
        params.put("country", country);
        params.put("displayName", displayName);
        params.put("address", address);

        if (cmd.equals(Constants.ADD)) {
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
                            if (userDao.getByEmail(email) != null) {
                                errors.add(new SubmissionError("An account with the same email already exists."));
                            } else {
                                UserImpl userImpl = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
                                userImpl.setCountry(country);
                                userDao.save(userImpl);
                                session.setAttribute("currentUser", userImpl, PortletSession.APPLICATION_SCOPE);
                            }
                        }


                    }
                }
            }
        } else if (cmd.equals(Constants.EDIT)) {
            if ((email == null) || email.isEmpty()) {
                errors.add(new SubmissionError("Email is required."));
            } else {
                if (!email.equals(email2)) {
                    errors.add(new SubmissionError("Confirm your email address."));
                } else {
                    UserImpl user = userDao.getById(userId);
                    user.setEmail(email);
                    if (password != null && password2 != null && password.length() >= 6 && password.equals(password2)) {
                        user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
                    }
                    if (displayName == null || displayName.isEmpty()) {
                        errors.add(new SubmissionError("Display Name is required."));
                    } else {
                        user.setDisplayName(displayName);
                        if (country == null || country.isEmpty()) {
                            errors.add(new SubmissionError("Country is required."));
                        } else {
                            user.setCountry(country);
                            user.setAddress(address);
                            userDao.update(user);
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
