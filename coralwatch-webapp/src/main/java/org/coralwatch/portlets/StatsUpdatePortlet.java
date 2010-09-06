package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.coralwatch.services.ReputationService;
import org.coralwatch.util.AppUtil;

import javax.portlet.*;
import java.io.IOException;
import java.util.List;


public class StatsUpdatePortlet extends GenericPortlet {
    private static Log _log = LogFactoryUtil.getLog(StatsUpdatePortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected ReefDao reefDao;
    protected SurveyDao surveyDao;
    private SurveyRecordDao surveyRecordDao;

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("stats-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        PortletPreferences prefs = renderRequest.getPreferences();
        List<UserImpl> users = userDao.getAll();
        List<Reef> reefs = reefDao.getAll();
        List<Survey> surveys = surveyDao.getAll();
        List<SurveyRecord> records = surveyRecordDao.getAll();
        renderRequest.setAttribute("users", users == null ? 0 : users.size());
        renderRequest.setAttribute("reefs", reefs == null ? 0 : reefs.size());
        renderRequest.setAttribute("surveys", surveys == null ? 0 : surveys.size());
        renderRequest.setAttribute("records", records == null ? 0 : records.size());
        renderRequest.setAttribute("highestContributor", ReputationService.getHighestContributor());
        renderRequest.setAttribute("userUrl", prefs.getValue("userUrl", "user"));
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        renderRequest.setAttribute("reefUrl", prefs.getValue("reefUrl", "reef"));
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
