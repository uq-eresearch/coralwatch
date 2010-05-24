package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.portlets.error.SubmissionError;

import javax.portlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ReefPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(ReefPortlet.class);
    protected String viewJSP;
    protected ReefDao reefDao;
    protected SurveyDao surveyDao;
    protected List<SubmissionError> errors;

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("reef-jsp");
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        errors = new ArrayList<SubmissionError>();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        PortletPreferences prefs = renderRequest.getPreferences();
        PortletSession session = renderRequest.getPortletSession();
        session.setAttribute("reefDao", reefDao, PortletSession.PORTLET_SCOPE);
        session.setAttribute("surveyDao", surveyDao, PortletSession.PORTLET_SCOPE);
        session.setAttribute("errors", errors, PortletSession.PORTLET_SCOPE);
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        include(viewJSP, renderRequest, renderResponse);
    }

    @Override
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession();
        errors = (List<SubmissionError>) session.getAttribute("errors", PortletSession.PORTLET_SCOPE);
        if (!errors.isEmpty()) {
            errors.clear();
        }

        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        _log.info("Command: " + cmd);
        try {
            
        } catch (Exception ex) {
            errors.add(new SubmissionError("Your submission contains invalid data. Check all fields."));
            _log.error("Submission error ", ex);
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

    @Override
    public void destroy() {
        if (_log.isInfoEnabled()) {
            _log.info("Destroying portlet");
        }
    }


}
