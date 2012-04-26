package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.coralwatch.util.Emailer;

import javax.mail.MessagingException;
import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

        String name = actionRequest.getParameter("name");
        String addressLine1 = actionRequest.getParameter("addressLine1");
        String addressLine2 = actionRequest.getParameter("addressLine2");
        String city = actionRequest.getParameter("city");
        String state = actionRequest.getParameter("state");
        String postcode = actionRequest.getParameter("postcode");
        String country = actionRequest.getParameter("country");
        String phone = actionRequest.getParameter("phone");
        String email = actionRequest.getParameter("email");
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

        if (name == null || name.isEmpty()) {
            errors.add("Name must be provided.");
        }
        
        if (
            (addressLine1 == null || addressLine1.isEmpty()) ||
            (city == null || city.isEmpty()) ||
            (state == null || state.isEmpty()) ||
            (postcode == null || postcode.isEmpty())
        ) {
            errors.add("Full address details not provided.");
        }

        if (country == null || country.isEmpty()) {
            errors.add("Country name must be supplied for kit request.");
        }
        if (errors.size() < 1) {
            KitRequest kitRequest = new KitRequest(user);
            kitRequest.setKitType(kitType);
            kitRequest.setLanguage(language);
            kitRequest.setName(name);
            kitRequest.setAddressLine1(addressLine1);
            kitRequest.setAddressLine2(addressLine2);
            kitRequest.setCity(city);
            kitRequest.setState(state);
            kitRequest.setPostcode(postcode);
            kitRequest.setCountry(country);
            kitRequest.setPhone(phone);
            kitRequest.setEmail(email);
            kitRequest.setNotes(notes);
            kitRequestDao.save(kitRequest);
            AppUtil.clearCache();

            String message = 
                "Dear " + kitRequest.getName() + "\n" +
                "\n" +
                "We have received your kit request. Your kit request details are below.\n" +
                "\n" +
                "Kit Type: " + kitRequest.getKitType() + "\n" +
                "Language: " + kitRequest.getLanguage() + "\n" +
                "Postal Address:\n" +
                "\n" +
                kitRequest.getAddressString() + "\n" +
                kitRequest.getCountry() + "\n" +
                "\n" +
                "Notes:\n" +
                "\n" +
                ((kitRequest.getNotes() == null || kitRequest.getNotes().isEmpty()) ? "(none provided)" : kitRequest.getNotes()) + "\n" +
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
