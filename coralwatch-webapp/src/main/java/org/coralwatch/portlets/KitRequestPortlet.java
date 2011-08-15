package org.coralwatch.portlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.mail.MessagingException;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.GenericPortlet;
import javax.portlet.PortletContext;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.PortletSession;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.coralwatch.util.Emailer;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;

public class KitRequestPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(KitRequestPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;
    protected KitRequestDao kitRequestDao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("kitrequest-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
        kitRequestDao = CoralwatchApplication.getConfiguration().getKitRequestDao();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("userUrl", prefs.getValue("userUrl", "user"));
        renderRequest.setAttribute("orderFormUrl", prefs.getValue("orderFormUrl", "http://coralwatch.org/c/document_library/get_file?p_l_id=10132&folderId=10790&name=DLFE-510.pdf"));
        renderRequest.setAttribute("kitrequestdao", kitRequestDao);
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {

        PortletSession session = actionRequest.getPortletSession();
        List<String> errors = new ArrayList<String>();

        String addressLine1 = actionRequest.getParameter("addressLine1");
        String addressLine2 = actionRequest.getParameter("addressLine2");
        String addressLine3 = actionRequest.getParameter("addressLine3");
        String city = actionRequest.getParameter("city");
        String state = actionRequest.getParameter("state");
        String postcode = actionRequest.getParameter("postcode");
        String country = actionRequest.getParameter("country");
        String kitType = actionRequest.getParameter("kitType");
        String language = actionRequest.getParameter("language");
        String notes = actionRequest.getParameter("notes");
//        boolean agreement = ParamUtil.getBoolean(actionRequest, "agreement");

        UserImpl user = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);

        if (user == null) {
            errors.add("You must be logged in to submit a kit request.");
        }
        if (kitType == null || kitType.isEmpty()) {
            errors.add("Kit type must be supplied for kit request.");
        }
        if (language == null || language.isEmpty()) {
            errors.add("Preferred language must be supplied for kit request.");
        }
//        if (!agreement) {
//            errors.add("You must agree to the terms and conditions to submit a kit request.");
//        }

        if (addressLine1 == null || addressLine1.isEmpty()) {
            errors.add("At least one address line must be supplied for kit request.");
        }
        if (city == null || city.isEmpty()) {
            errors.add("City / suburb must be supplied for kit request.");
        }
        if (state == null || state.isEmpty()) {
            errors.add("State / province / region must be supplied for kit request.");
        }
        if (postcode == null || postcode.isEmpty()) {
            errors.add("Post code / ZIP code must be supplied for kit request.");
        }
        if (country == null || country.isEmpty()) {
            errors.add("Country name must be supplied for kit request.");
        }
        
        if (errors.size() < 1) {
            KitRequest kitRequest = new KitRequest(user);
            kitRequest.setKitType(kitType);
            kitRequest.setLanguage(language);
            kitRequest.setAddressLine1(addressLine1);
            kitRequest.setAddressLine2(addressLine2);
            kitRequest.setAddressLine3(addressLine3);
            kitRequest.setCity(city);
            kitRequest.setState(state);
            kitRequest.setPostcode(postcode);
            kitRequest.setCountry(country);
            kitRequest.setNotes(notes);
            kitRequestDao.save(kitRequest);
            AppUtil.clearCache();

            //send confirmation email
            String name = user.getDisplayName();

            if (user.getFirstName() != null && user.getLastName() != null) {
                name = user.getFirstName() + " " + user.getLastName();
            }

            String message =
                "Dear " + name + "\n" +
                "\n" +
                "We have received your kit request. Your kit request details are below." + "\n" +
                "\n" +
                "Kit Type: " + kitType + "\n" +
                "Language: " + language + "\n" +
                "Postal Address:\n" +
                "\n" +
                kitRequest.getAddressListing() + "\n" +
                "\n" +
                "Notes: " + (notes == null ? "" : notes) + "\n" +
                "\n" +
                "We will send you an email when your request is dispatched.\n" +
                "\n" +
                "Regards,\n" +
                "CoralWatch\n" +
                "http://coralwatch.org";
            
            try {
                Emailer.sendEmail(user.getEmail(), "no-reply@coralwatch.org", "CoralWatch Kit Request", message);
                actionResponse.setRenderParameter("successMsg", "We have received your kit request. We have sent you a confirmation email. Check your email in few minutes.");
                actionResponse.setRenderParameter(Constants.CMD, Constants.PRINT);
            } catch (MessagingException e) {
                _log.fatal("Cannot send email for Password Reset request.");
            }


        } else {
            actionRequest.setAttribute("errors", errors);
        }
        actionRequest.setAttribute("kitrequestdao", kitRequestDao);

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
