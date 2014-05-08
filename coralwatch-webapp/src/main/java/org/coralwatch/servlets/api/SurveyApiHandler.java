package org.coralwatch.servlets.api;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
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
        response.setStatus(200);
        response.setContentType("application/json");
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.object();
            writer.key("url").value(String.format("/coralwatch/api/survey/%d", + survey.getId()));
            writer.key("groupName").value(survey.getGroupName());
            writer.key("participatingAs").value(survey.getParticipatingAs());
            writer.key("reef");
            writer.object();
            writer.key("name").value(survey.getReef().getName());
            writer.key("country").value(survey.getReef().getCountry());
            writer.key("portalUrl").value(String.format(
                "/web/guest/reef" +
                "?p_p_id=reefportlet_WAR_coralwatch" +
                "&_reefportlet_WAR_coralwatch_cmd=view" +
                "&_reefportlet_WAR_coralwatch_reefId=%d",
                survey.getReef().getId()
            ));
            writer.endObject();
            writer.key("latitude").value(survey.getLatitude());
            writer.key("longitude").value(survey.getLongitude());
            writer.key("date").value((new SimpleDateFormat("yyyy-MM-dd")).format(survey.getDate()));
            writer.key("time").value((new SimpleDateFormat("HH:mm")).format(survey.getTime()));
            writer.key("lightCondition").value(survey.getLightCondition());
            writer.key("depth").value(survey.getDepth());
            writer.key("waterTemperature").value(survey.getWaterTemperature());
            writer.key("activity").value(survey.getActivity());
            writer.key("comments").value(survey.getComments());
            writer.key("records");
            writer.array();
            for (SurveyRecord surveyRecord : survey.getDataset()) {
                SurveyRecordApiHandler.writeSurveyRecord(surveyRecord, writer);
            }
            writer.endArray();
            writer.key("portalUrl").value(String.format(
                "/web/guest/survey" +
                "?p_p_id=surveyportlet_WAR_coralwatch" +
                "&_surveyportlet_WAR_coralwatch_cmd=view" +
                "&_surveyportlet_WAR_coralwatch_surveyId=%d",
                survey.getId()
            ));
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }
}
