package org.coralwatch.servlets.api;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.json.JSONException;
import org.json.JSONWriter;

// TODO: Remove code duplication from SurveyPortlet
public class SurveyApiHandler {
    private SurveyDao surveyDao;
    private Long surveyId;

    public SurveyApiHandler(Long surveyId) {
        this.surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        this.surveyId = surveyId;
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Survey survey = surveyDao.getById(surveyId);
        if (survey == null) {
            response.setStatus(404);
            return;
        }
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.object();
            writer.key("id").value(survey.getId());
            writer.key("groupName").value(survey.getGroupName());
            writer.key("participatingAs").value(survey.getParticipatingAs());
            writer.key("country").value(survey.getReef().getCountry());
            writer.key("reefName").value(survey.getReef().getName());
            writer.key("latitude").value(survey.getLatitude());
            writer.key("longitude").value(survey.getLongitude());
            writer.key("date").value((new SimpleDateFormat("yyyy-MM-dd")).format(survey.getDate()));
            writer.key("time").value((new SimpleDateFormat("HH:mm")).format(survey.getTime()));
            writer.key("lightCondition").value(survey.getLightCondition());
            writer.key("depth").value(survey.getDepth());
            writer.key("waterTemperature").value(survey.getWaterTemperature());
            writer.key("activity").value(survey.getActivity());
            writer.key("comments").value(survey.getComments());
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
        response.setStatus(200);
    }
}
