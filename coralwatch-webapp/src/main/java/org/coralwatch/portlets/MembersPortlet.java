package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.util.AppUtil;

import javax.portlet.*;
import java.io.IOException;

public class MembersPortlet extends GenericPortlet {
    private static Log _log = LogFactoryUtil.getLog(MembersPortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected SurveyDao surveyDao;

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("members-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        String cmd = ParamUtil.getString(renderRequest, Constants.CMD);
        String userId = ParamUtil.getString(renderRequest, "userId");
        if (cmd.equals(Constants.VIEW)) {
            include(getInitParameter("registration-jsp"), renderRequest, renderResponse);
        }
        renderRequest.setAttribute("surveyDao", surveyDao);
        renderRequest.setAttribute("userDao", userDao);
        include(viewJSP, renderRequest, renderResponse);
    }

    @Override
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
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

    @Override
    public void destroy() {
        if (_log.isInfoEnabled()) {
            _log.info("Destroying portlet");
        }
    }


}
