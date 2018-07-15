package org.coralwatch.servlets.api;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.util.AppUtil;
import org.coralwatch.model.UserImpl;

import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;

import com.google.gson.Gson;
import org.json.JSONException;
import org.json.JSONWriter;

public class StatsApiHandler {

    private UserDao userDao;
    private ReefDao reefDao;
    private SurveyDao surveyDao;
    private SurveyRecordDao surveyRecordDao;

    public StatsApiHandler() {
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int users = userDao.count("");
        int reefs = reefDao.count("");
        int surveys = surveyDao.count("");
        int records = surveyRecordDao.count("");
        String baseUrl = CoralwatchApplication.getConfiguration().getBaseUrl();
        UserImpl highestContributor = userDao.getHighestContributor();

        response.setStatus(200);
        response.setContentType("application/json; charset=UTF-8");

        if ( StringUtils.equalsIgnoreCase(request.getParameter("value"), "users") ) {
            response.getWriter().write(users);
        }
        else if ( StringUtils.equalsIgnoreCase(request.getParameter("value"), "reefs") ) {
            response.getWriter().write(reefs);
        }
        else if ( StringUtils.equalsIgnoreCase(request.getParameter("value"), "surveys") ) {
            response.getWriter().write(surveys);
        }
        else if ( StringUtils.equalsIgnoreCase(request.getParameter("value"), "records") ) {
            response.getWriter().write(records);
        }
        else if ( StringUtils.equalsIgnoreCase(request.getParameter("value"), "baseUrl") ) {
            response.getWriter().write(baseUrl);
        }
        else if ( StringUtils.equalsIgnoreCase(request.getParameter("value"), "highestContributor") ) {
            response.getWriter().write(highestContributor.getDisplayName());
        }
        else {
            // Will return a JSON object with all the stats values
            JSONWriter writer = new JSONWriter(response.getWriter());

            try {
                writer.object();
                writer.key("users").value(users);
                writer.key("reefs").value(reefs);
                writer.key("surveys").value(surveys);
                writer.key("records").value(records);
                writer.key("baseUrl").value(baseUrl);
                writer.key("highestContributor").value(highestContributor.getDisplayName());
                writer.endObject();

            } catch (JSONException e) {
                throw new IOException(e);
            }
        }

    }
}
