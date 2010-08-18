package org.coralwatch.portlets;

import au.edu.uq.itee.maenad.util.BCrypt;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.UserRatingDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(UserPortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected UserRatingDao userRatingDao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("user-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        userRatingDao = CoralwatchApplication.getConfiguration().getRatingDao();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        renderRequest.setAttribute("userDao", userDao);
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        renderRequest.setAttribute("userPageUrl", prefs.getValue("userPageUrl", "user"));
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession(true);
        List<String> errors = new ArrayList<String>();
        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);

        String email = actionRequest.getParameter("email");
        String email2 = actionRequest.getParameter("email2");
        String password = actionRequest.getParameter("password");
        String password2 = actionRequest.getParameter("password2");
        String country = actionRequest.getParameter("country");
        String displayName = actionRequest.getParameter("displayName");
        String occupation = actionRequest.getParameter("occupation");
        String qualification = actionRequest.getParameter("qualification");
        String address = actionRequest.getParameter("address");
        long userId = ParamUtil.getLong(actionRequest, "userId");

        if (cmd.equals(Constants.ADD)) {
            if ((email == null) || email.isEmpty() || (displayName == null) || displayName.isEmpty() || (password == null) || (country == null) || country.isEmpty()) {
                errors.add("All fields are required.");
            } else {
                //TODO validate email
                if (!email.equals(email2)) {
                    errors.add("Confirm your email address.");
                } else {
                    if (password.length() < 6) {
                        errors.add("Password must be at least 6 characters.");
                    } else {
                        if (!password.equals(password2)) {
                            errors.add("Confirm your password.");
                        } else {
                            if (userDao.getByEmail(email) != null) {
                                errors.add("An account with the same email already exists.");
                            } else {
                                UserImpl userImpl = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
                                userImpl.setCountry(country);
                                userDao.save(userImpl);
                                actionResponse.setRenderParameter("userId", String.valueOf(userImpl.getId()));
                                actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                                session.setAttribute("currentUser", userImpl, PortletSession.APPLICATION_SCOPE);
                            }
                        }


                    }
                }
            }
            if (errors.size() > 0) {
                actionResponse.setRenderParameter(Constants.CMD, Constants.ADD);
                actionRequest.setAttribute("errors", errors);
            }
        } else if (cmd.equals(Constants.EDIT)) {
            if ((email == null) || email.isEmpty()) {
                errors.add("Email is required.");
            } else {
                if (!email.equals(email2)) {
                    errors.add("Confirm your email address.");
                } else {
                    UserImpl userByEmail = userDao.getByEmail(email);
                    if (userByEmail != null && userByEmail.getId() != userId) {
                        errors.add("Email address is already used.");
                    } else {
                        if (displayName == null || displayName.isEmpty()) {
                            errors.add("Display name is required.");
                        } else {
                            if (country == null || country.isEmpty()) {
                                errors.add("Country is required.");
                            } else {
                                UserImpl user = userDao.getById(userId);
                                if (password != null && password2 != null && password.length() >= 6 && password.equals(password2)) {
                                    user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
                                }
                                user.setEmail(email);
                                user.setDisplayName(displayName);
                                user.setCountry(country);
                                user.setOccupation(occupation);
                                user.setQualification(qualification);
                                user.setAddress(address);
                                userDao.update(user);
                                AppUtil.clearCache();
                                actionResponse.setRenderParameter("userId", String.valueOf(user.getId()));
                                actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);

                            }
                        }
                    }

                }
            }
            if (errors.size() > 0) {
                actionResponse.setRenderParameter("userId", String.valueOf(userId));
                actionResponse.setRenderParameter(Constants.CMD, Constants.EDIT);
                actionRequest.setAttribute("errors", errors);
            }
        } else if (cmd.equals(Constants.RESET)) {
            String resetPassword = actionRequest.getParameter("resetpassword");
            String resetPassword2 = actionRequest.getParameter("resetpassword2");
            String resetid = actionRequest.getParameter("resetid");
            if (resetPassword.length() < 6) {
                errors.add("Password must be at least 6 characters.");
            } else {
                UserImpl user = userDao.getById(userId);
                if (resetid.equals(user.getPasswordResetId())) {
                    user.setPasswordHash(BCrypt.hashpw(resetPassword, BCrypt.gensalt()));
                    UUID uuid = UUID.randomUUID();
                    String passwordResetId = uuid.toString();
                    user.setPasswordResetId(passwordResetId);
                    userDao.update(user);
                    AppUtil.clearCache();
//                    actionResponse.setRenderParameter("userId", String.valueOf(user.getId()));
                    actionResponse.setRenderParameter("successMsg", "Your password has been updated successfully.");
                    actionResponse.setRenderParameter(Constants.CMD, Constants.PRINT);
                } else {
                    errors.add("Invalid password reset request.");
                }
            }
            if (errors.size() > 0) {
                actionResponse.setRenderParameter("userId", String.valueOf(userId));
                actionResponse.setRenderParameter("resetid", String.valueOf(resetid));
                actionResponse.setRenderParameter(Constants.CMD, Constants.RESET);
                actionRequest.setAttribute("errors", errors);
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
