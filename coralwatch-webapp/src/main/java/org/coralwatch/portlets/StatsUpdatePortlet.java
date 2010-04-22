package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.UserDao;

import javax.portlet.*;
import java.io.IOException;


public class StatsUpdatePortlet extends GenericPortlet {
    private static Log _log = LogFactoryUtil.getLog(StatsUpdatePortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected ReefDao reefDao;
    protected SurveyDao surveyDao;

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("stats-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        PortletSession session = renderRequest.getPortletSession();
        session.setAttribute("userDao", userDao, PortletSession.PORTLET_SCOPE);
        session.setAttribute("reefDao", reefDao, PortletSession.PORTLET_SCOPE);
        session.setAttribute("surveyDao", surveyDao, PortletSession.PORTLET_SCOPE);
        include(viewJSP, renderRequest, renderResponse);
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
