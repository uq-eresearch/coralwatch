package org.coralwatch.portlets;

import java.io.IOException;
import java.text.SimpleDateFormat;

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
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;

public class MapPortlet extends GenericPortlet {
    private static Log _log = LogFactoryUtil.getLog(SurveyPortlet.class);
    protected String viewJSP;
    protected UserDao userdao;
    protected SurveyDao surveyDao;
    protected ReefDao reefDao;

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("map-jsp");
        userdao = CoralwatchApplication.getConfiguration().getUserDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        renderRequest.setAttribute("surveyDao", surveyDao);
        renderRequest.setAttribute("reefs", reefDao.getAll());
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        include(viewJSP, renderRequest, renderResponse);
    }

    @Override
    public void serveResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        if (request.getResourceID().equals("survey")) {
            serveSurveyResource(request, response);
        }
    }

    private void serveSurveyResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        UserImpl currentUser = (UserImpl) request.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
        Survey survey = surveyDao.getById(Long.valueOf(request.getParameter("id")));
        String baseUrl = request.getContextPath();
        String piechartUrl = baseUrl + "/graph?type=survey&id=" + survey.getId() + "&chart=shapePie&width=256&height=256&labels=false&legend=true&titleSize=11";
        String coralcountchartUrl = baseUrl + "/graph?type=survey&id=" + survey.getId() + "&chart=coralCount&width=256&height=256&legend=false&titleSize=11";
        int numberOfRecs = surveyDao.getSurveyRecords(survey).size();
        String graphs = (numberOfRecs <= 0) ? "" : "<br /><img src=\"" + piechartUrl + "\" alt=\"Shape Distribution\" width=\"256\" height=\"256\"/><img src=\"" + coralcountchartUrl + "\" alt=\"Shape Distribution\" width=\"256\" height=\"256\"/>";
        String country = survey.getReef().getCountry();
        if ((country == null) || country.toLowerCase().startsWith("unknown")) {
            country = "";
        }
        response.getWriter().println("<b>" + survey.getReef().getName() + " (" + country + ")</b><br />");
        if ((currentUser != null) && currentUser.isSuperUser()) {
            String reviewStateImgUrl = request.getContextPath() + "/icon/timemap/" + survey.getReviewState().getColour() + "-circle.png";
            response.getWriter().println("<div style=\"float: right;\">");
            response.getWriter().println("<img src=\"" + reviewStateImgUrl + "\" />");
            response.getWriter().println(survey.getReviewState().getText());
            response.getWriter().println("</div>");
        }
        String surveyUrl =
            request.getPreferences().getValue("surveyUrl", "survey") +
            "?p_p_id=surveyportlet_WAR_coralwatch" +
            "&_surveyportlet_WAR_coralwatch_" + Constants.CMD + "=" + Constants.VIEW +
            "&_surveyportlet_WAR_coralwatch_surveyId=" + survey.getId();
        response.getWriter().println("- <a href=\"" + surveyUrl + "\">" + numberOfRecs + " Record(s)</a><br />");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
        response.getWriter().println("- " + dateFormat.format(survey.getDate()) + graphs + "<br />");
        response.getWriter().println("<div dojoType='dojox.form.Rating' numStars='5' value='1'></div>");
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

