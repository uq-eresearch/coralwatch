package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class JsonSurveyServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(JsonSurveyServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json");
        PrintWriter out = res.getWriter();
        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        JSONArray surveys = new JSONArray();
        List<Survey> listOfSurveys = surveyDao.getAll();
        for (Survey srv : listOfSurveys) {
            try {
                JSONObject survey = new JSONObject();
                survey.putOpt("id", srv.getId());
                survey.putOpt("reef", srv.getReef().getName());
                survey.putOpt("latitude", srv.getLatitude());
                survey.putOpt("longitude", srv.getLongitude());
                survey.putOpt("records", surveyDao.getSurveyRecords(srv).size());
                survey.putOpt("date", srv.getDate().toLocaleString());
                surveys.put(survey);
            } catch (JSONException e) {
                LOGGER.fatal("Cannot create survey json object." + e.toString());
            }
        }
        JSONObject data = new JSONObject();
        try {
            data.putOpt("count", listOfSurveys.size());
            data.putOpt("surveys", surveys);
        } catch (JSONException ex) {
            LOGGER.fatal("Cannot create data json object." + ex.toString());
        }
        out.println(data);
    }

}
