package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.portlets.error.SubmissionError;

import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class KitRequestPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(JSPPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;
    protected KitRequestDao kitRequestDao;
    protected List<SubmissionError> errors;

    public void init() throws PortletException {
        viewJSP = getInitParameter("kitrequest-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
        kitRequestDao = CoralwatchApplication.getConfiguration().getKitRequestDao();
        errors = new ArrayList<SubmissionError>();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        PortletSession session = renderRequest.getPortletSession();
        session.setAttribute("kitrequestdao", kitRequestDao, PortletSession.PORTLET_SCOPE);
        session.setAttribute("errors", errors, PortletSession.PORTLET_SCOPE);
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {

        PortletSession session = actionRequest.getPortletSession();
        ((List<SubmissionError>) session.getAttribute("errors")).clear();

        String address = actionRequest.getParameter("address");
        String notes = actionRequest.getParameter("notes");
        boolean agreement = ParamUtil.getBoolean(actionRequest, "agreement");

        UserImpl user = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);

        if (user == null) {
            errors.add(new SubmissionError("You must be logged in to submit a kit request."));
        }
        if (!agreement) {
            errors.add(new SubmissionError("You must agree to the terms and conditions to submit a kit request."));
        }

        if (address == null || address.isEmpty()) {
            errors.add(new SubmissionError("No address was provided. Postal address must be supplied for kit request."));
        }
        if (errors.isEmpty()) {

            KitRequest kitRequest = new KitRequest(user);
            kitRequest.setAddress(address);
            kitRequest.setNotes(notes);
            kitRequestDao.save(kitRequest);
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
