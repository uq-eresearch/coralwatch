package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;

import javax.portlet.*;
import java.io.IOException;

public class KitRequestPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(JSPPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;
    protected KitRequestDao kitRequestDao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("kitrequest-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
        kitRequestDao = CoralwatchApplication.getConfiguration().getKitRequestDao();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        String address = actionRequest.getParameter("address");
        String notes = actionRequest.getParameter("notes");
        boolean agreement = ParamUtil.getBoolean(actionRequest, "agreement");

        if (agreement) {
            //TODO change this to use the current logged in user
            UserImpl user = userdao.getById(new Long(1));

            KitRequest kitRequest = new KitRequest(user);
            if (address == null || address.isEmpty()) {

            } else {
                kitRequest.setAddress(address);
            }
            kitRequest.setNotes(notes);

            kitRequestDao.save(kitRequest);
            _log.info("===number of kit requests: " + kitRequestDao.getAll().size() + " =======");
            actionResponse.sendRedirect("/user-management/registration.jsp");
        } else {
            _log.error("===You must agree to the terms and conditions.=======");
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
