package org.coralwatch.servlets.api;

import java.io.IOException;

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
            // TODO: Add other Survey attributes to JSON serialisations.
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
        response.setStatus(200);
    }
}
