package org.coralwatch.servlets.api;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

// TODO: Share code with SurveyRecordServlet
public class SurveyRecordListApiHandler {
    private SurveyDao surveyDao;
    private SurveyRecordDao surveyRecordDao;
    private Long surveyId;

    public SurveyRecordListApiHandler(Long surveyId) {
        this.surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        this.surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        this.surveyId = surveyId;
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> errors = new ArrayList<String>();

        UserImpl currentUser = AppUtil.getCurrentUser(request);
        if (currentUser == null) {
            errors.add("You must be signed in to submit a survey.");
            ApiServletUtils.writeErrorResponse(response, 403, errors);
            return;
        }

        Survey survey = surveyDao.getById(surveyId);
        if (survey == null) {
            response.setStatus(404);
            return;
        }

        String coralType = request.getParameter("coralType");
        List<String> coralTypes = Arrays.asList("Boulder", "Branching", "Plate", "Soft");
        if (!coralTypes.contains(coralType)) {
            errors.add("Invalid Coral Type: must be one of " + StringUtils.join(coralTypes, ", ") + ".");
        }
        String lightest = request.getParameter("lightest");
        String darkest = request.getParameter("darkest");
        Pattern colorPattern = Pattern.compile("(?i)([BCDE])([123456])");
        if (!colorPattern.matcher(lightest).matches() || !colorPattern.matcher(darkest).matches()) {
            errors.add("Values for Lightest/Darkest should be a letter (B, C, D, E) followed by a number (1-6).");
        }
        if (!errors.isEmpty()) {
            ApiServletUtils.writeErrorResponse(response, 400, errors);
            return;
        }
        
        char lightestLetter = lightest.charAt(0);
        int lightestNumber = Integer.parseInt(String.valueOf(lightest.charAt(1)));
        char darkestLetter = darkest.charAt(0);
        int darkestNumber = Integer.parseInt(String.valueOf(darkest.charAt(1)));

        SurveyRecord surveyRecord = new SurveyRecord(survey, coralType, lightestLetter, lightestNumber, darkestLetter, darkestNumber);
        survey.getDataset().add(surveyRecord);
        surveyRecordDao.save(surveyRecord);

        response.setStatus(201);
        response.setHeader("Location", String.format("/coralwatch/api/survey/%d/record/%d", + survey.getId(), surveyRecord.getId()));
    }
}
