package org.coralwatch.servlets.api;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.json.JSONException;
import org.json.JSONWriter;

// TODO: Remove code duplication from SurveyPortlet
public class SurveyApiServlet extends HttpServlet {
    protected SurveyDao surveyDao;
    protected SurveyRecordDao surveyRecordDao;
    protected ReefDao reefDao;

    @Override
    public void init() throws ServletException {
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserImpl currentUser = (session != null) ? (UserImpl) session.getAttribute("currentUser") : null;
        List<String> errors = new ArrayList<String>();
        if (currentUser == null) {
            errors.add("You must be signed in to submit a survey.");
            ApiServletUtils.writeErrorResponse(response, errors);
            return;
        }

        String groupName = request.getParameter("groupName");
        String participatingAs = request.getParameter("participatingAs");
        String country = request.getParameter("country");
        String reefName = request.getParameter("reefName");
        String latitudeStr = request.getParameter("latitude");
        String longitudeStr = request.getParameter("longitude");
        String isGpsDeviceParam = request.getParameter("isGpsDevice");
        boolean isGpsDevice = Boolean.parseBoolean(isGpsDeviceParam);
        String dateParam = request.getParameter("date");
        SimpleDateFormat dateParamFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = (dateParam != null) ? dateParamFormat.parse(dateParam) : null;
        }
        catch (ParseException e1) {
            errors.add("Invalid date value: must match " + dateParamFormat.toPattern() + ".");
        }
        String timeParam = request.getParameter("time");
        SimpleDateFormat timeParamFormat = new SimpleDateFormat("HH:mm");
        Date time = null;
        try {
            time = (timeParam != null) ? timeParamFormat.parse(timeParam) : null;
        }
        catch (ParseException e1) {
            errors.add("Invalid time value: must match " + timeParamFormat.toPattern() + ".");
        }
        String lightCondition = request.getParameter("lightCondition");
        String activity = request.getParameter("activity");
        String comments = request.getParameter("comments");

        validateEmptyFields(
            errors,
            groupName,
            participatingAs,
            country,
            reefName,
            latitudeStr,
            longitudeStr,
            dateParam,
            timeParam,
            lightCondition,
            activity
        );

        String latitudeParam = request.getParameter("latitude");
        Float latitude = StringUtils.isNotBlank(latitudeParam) ? Float.parseFloat(latitudeParam) : null;
        String longitudeParam = request.getParameter("longitude");
        Float longitude = StringUtils.isNotBlank(longitudeParam) ? Float.parseFloat(longitudeParam) : null;

        String depthDisabledParam = request.getParameter("depthDisabled");
        boolean depthDisabled = Boolean.parseBoolean(depthDisabledParam);
        Double depth = null;
        String depthParam = request.getParameter("depth");
        if (!depthDisabled) {
            if (StringUtils.isBlank(depthParam)) {
                errors.add("Depth is a required field unless marked 'not available'.");
            }
            else {
                try {
                    depth = Double.parseDouble(depthParam);
                }
                catch (NumberFormatException e) {
                    errors.add("Depth not a valid number'.");
                }
            }
        }

        String waterTemperatureDisabledParam = request.getParameter("waterTemperatureDisabled");
        boolean waterTemperatureDisabled = Boolean.parseBoolean(waterTemperatureDisabledParam);
        Double waterTemperature = null;
        String waterTemperatureParam = request.getParameter("waterTemperature");
        if (!waterTemperatureDisabled) {
            if (StringUtils.isBlank(waterTemperatureParam)) {
                errors.add("Water temperature is a required field unless marked 'not available'.");
            }
            else {
                try {
                    waterTemperature = Double.parseDouble(waterTemperatureParam);
                }
                catch (NumberFormatException e) {
                    errors.add("Water temperature not a valid number.");
                }
            }
        }

        if (errors.isEmpty()) {
            Reef reef = reefDao.getReefByName(reefName);
            if (reef == null) {
                reef = new Reef(reefName, country);
                reefDao.save(reef);
            }
            Survey survey = new Survey();
            survey.setCreator(currentUser);
            survey.setGroupName(groupName);
            survey.setParticipatingAs(participatingAs);
            survey.setReef(reef);
            survey.setQaState("Post Migration");
            survey.setLatitude(latitude);
            survey.setLongitude(longitude);
            survey.setGPSDevice(isGpsDevice);
            survey.setDate(date);
            survey.setTime(time);
            survey.setLightCondition(lightCondition);
            survey.setDepth(depth);
            survey.setWaterTemperature(waterTemperature);
            survey.setActivity(activity);
            survey.setComments(comments);
            survey.setReviewState(Survey.ReviewState.UNREVIEWED);
            surveyDao.save(survey);

            writeSuccessResponse(response, survey);
        }
        else {
            ApiServletUtils.writeErrorResponse(response, errors);
        }
    }

    private void writeSuccessResponse(HttpServletResponse response, Survey survey) throws IOException {
        response.setStatus(200);
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.object();
            String surveyUrl = String.format(
                "/web/guest/survey" +
                "?p_p_id=surveyportlet_WAR_coralwatch" +
                "&_surveyportlet_WAR_coralwatch_cmd=view" +
                "&_surveyportlet_WAR_coralwatch_surveyId=%d",
                survey.getId()
            );
            writer.key("portalUrl").value(surveyUrl);
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }

    private void validateEmptyFields(
        List<String> errors,
        String groupName,
        String participatingAs,
        String country,
        String reefName,
        String latitudeStr,
        String longitudeStr,
        String date,
        String time,
        String lightCondition,
        String activity
    ) {
        List<String> emptyFields = new ArrayList<String>();
        if (groupName == null || groupName.trim().isEmpty()) {
            emptyFields.add("Group Name");
        }
        if (participatingAs == null || participatingAs.trim().isEmpty()) {
            emptyFields.add("Participating As");
        }
        if (country == null || country.trim().isEmpty()) {
            emptyFields.add("Country");
        }
        if (reefName == null || reefName.trim().isEmpty()) {
            emptyFields.add("Reef Name");
        }
        if (latitudeStr == null || latitudeStr.trim().isEmpty()) {
            emptyFields.add("Latitude");
        }
        if (longitudeStr == null || longitudeStr.trim().isEmpty()) {
            emptyFields.add("Longitude");
        }
        if (date == null || date.trim().isEmpty()) {
            emptyFields.add("Date");
        }
        if (time == null || time.trim().isEmpty()) {
            emptyFields.add("Time");
        }
        if (lightCondition == null || lightCondition.trim().isEmpty()) {
            emptyFields.add("Light Condition");
        }
        if (activity == null || activity.trim().isEmpty()) {
            emptyFields.add("Activity");
        }

        if (!emptyFields.isEmpty()) {
            String fields = "";
            for (String field : emptyFields) {
                fields = fields + " " + field;
            }
            errors.add("Required field(s):" + fields + ".");
        }
    }
}
