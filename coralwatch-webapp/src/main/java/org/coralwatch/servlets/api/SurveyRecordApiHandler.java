package org.coralwatch.servlets.api;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.SurveyRecord;
import org.json.JSONException;
import org.json.JSONWriter;

// TODO: Remove code duplication from SurveyPortlet
public class SurveyRecordApiHandler {
    private SurveyRecordDao surveyRecordDao;
    private Long surveyRecordId;

    public SurveyRecordApiHandler(Long surveyRecordId) {
        this.surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        this.surveyRecordId = surveyRecordId;
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SurveyRecord surveyRecord = surveyRecordDao.getById(surveyRecordId);
        if (surveyRecord == null) {
            response.setStatus(404);
            return;
        }
        response.setStatus(200);
        response.setContentType("application/json");
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writeSurveyRecord(surveyRecord, writer);
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }

    public static void writeSurveyRecord(SurveyRecord surveyRecord, JSONWriter writer) throws JSONException {
        writer.object();
        writer.key("url").value(String.format("/coralwatch/api/survey/%d/record/%d", + surveyRecord.getSurvey().getId(), surveyRecord.getId()));
        writer.key("surveyUrl").value(String.format("/coralwatch/api/survey/%d", + surveyRecord.getSurvey().getId()));
        writer.key("coralType").value(surveyRecord.getCoralType());
        writer.key("lightest").value(surveyRecord.getLightestLetter() + surveyRecord.getLightestNumber());
        writer.key("darkest").value(surveyRecord.getDarkestLetter() + surveyRecord.getDarkestNumber());
        writer.endObject();
    }
}
