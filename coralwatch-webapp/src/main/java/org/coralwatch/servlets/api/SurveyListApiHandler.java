package org.coralwatch.servlets.api;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

// TODO: Remove code duplication from SurveyPortlet
public class SurveyListApiHandler {
    private SurveyDao surveyDao;
    private ReefDao reefDao;

    public SurveyListApiHandler() {
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> errors = new ArrayList<String>();

        UserImpl currentUser = AppUtil.getCurrentUser(request);
        if (currentUser == null) {
            errors.add("You must be signed in to submit a survey.");
            ApiServletUtils.writeErrorResponse(response, 403, errors);
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

        if (!errors.isEmpty()) {
            ApiServletUtils.writeErrorResponse(response, 400, errors);
            return;
        }

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

        response.setStatus(201);
        response.setHeader("Location", String.format("/coralwatch/api/survey/%d", survey.getId()));
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
            errors.add("Required fields: " + StringUtils.join(emptyFields, ", ") + ".");
        }
    }
}
