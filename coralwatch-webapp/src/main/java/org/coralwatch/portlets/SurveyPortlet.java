package org.coralwatch.portlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.coralwatch.portlets.error.SubmissionError;

import javax.portlet.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SurveyPortlet extends GenericPortlet {
    private static Log _log = LogFactoryUtil.getLog(SurveyPortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected SurveyDao surveyDao;
    protected SurveyRecordDao surveyRecordDao;
    protected ReefDao reefDao;
    protected List<SubmissionError> errors;

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("survey-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        errors = new ArrayList<SubmissionError>();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        renderRequest.setAttribute("surveyDao", surveyDao);
        renderRequest.setAttribute("userDao", userDao);
        renderRequest.setAttribute("surveyRecordDao", surveyRecordDao);
        renderRequest.setAttribute("reefDao", reefDao);
        renderRequest.setAttribute("errors", errors);
        include(viewJSP, renderRequest, renderResponse);
    }

    @Override
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession();
        if (!errors.isEmpty()) {
            errors.clear();
        }

        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        _log.info("Command: " + cmd);
        try {
            if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
                UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
                if (currentUser != null) {
                    String organisation = actionRequest.getParameter("organisation");
                    String organisationType = actionRequest.getParameter("organisationType");
                    String country = actionRequest.getParameter("country");
                    String reefName = actionRequest.getParameter("reefName");
                    String latitudeStr = actionRequest.getParameter("latitude");
                    float latitude = ParamUtil.getFloat(actionRequest, "latitude");
                    String longitudeStr = actionRequest.getParameter("longitude");
                    float longitude = ParamUtil.getFloat(actionRequest, "longitude");
                    boolean isGpsDevice = ParamUtil.getBoolean(actionRequest, "isGpsDevice");
                    Date date = ParamUtil.getDate(actionRequest, "date", new SimpleDateFormat("yyyy-MM-dd"));
                    Date time = ParamUtil.getDate(actionRequest, "time", new SimpleDateFormat("'T'HH:mm:ss"));
                    String weather = actionRequest.getParameter("weather");
                    String temperatureStr = actionRequest.getParameter("temperature");
                    double temperature = ParamUtil.getDouble(actionRequest, "temperature");
                    String activity = actionRequest.getParameter("activity");
                    String comments = actionRequest.getParameter("comments");

                    validateEmptyFields(organisation, organisationType, country, reefName, latitudeStr, longitudeStr, date, time, weather, temperatureStr, activity);

                    if (errors.isEmpty()) {
                        Reef reef = reefDao.getReefByName(reefName);
                        if (reef == null) {
                            Reef newReef = new Reef(reefName, country);
                            reefDao.save(newReef);
                        }
                        if (cmd.equals(Constants.ADD)) {
                            Survey survey = new Survey();
                            survey.setCreator(currentUser);
                            survey.setOrganisation(organisation);
                            survey.setOrganisationType(organisationType);
                            survey.setReef(reef);
                            survey.setLatitude(latitude);
                            survey.setLongitude(longitude);
                            survey.setGPSDevice(isGpsDevice);
                            survey.setDate(date);
                            survey.setTime(time);
                            survey.setWeather(weather);
                            survey.setTemperature(temperature);
                            survey.setActivity(activity);
                            survey.setComments(comments);
                            surveyDao.save(survey);
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                            actionResponse.setRenderParameter("selectedTab", "metadataTab");
                            _log.info("Added survey");
                        } else if (cmd.equals(Constants.EDIT)) {
                            long suveyId = ParamUtil.getLong(actionRequest, "surveyId");
                            Survey survey = surveyDao.getById(suveyId);
                            survey.setDateModified(new Date());
                            survey.setOrganisation(organisation);
                            survey.setOrganisationType(organisationType);
                            survey.setReef(reef);
                            survey.setLatitude(latitude);
                            survey.setLongitude(longitude);
                            survey.setGPSDevice(isGpsDevice);
                            survey.setDate(date);
                            survey.setTime(time);
                            survey.setWeather(weather);
                            survey.setTemperature(temperature);
                            survey.setActivity(activity);
                            survey.setComments(comments);
                            surveyDao.update(survey);
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                            actionResponse.setRenderParameter("selectedTab", "metadataTab");
                            _log.info("Added survey");
                        }
                    } else {
                        actionResponse.setRenderParameter(Constants.CMD, cmd);
                        if (cmd.equals(Constants.EDIT)) {
                            actionResponse.setRenderParameter("surveyId", String.valueOf(ParamUtil.getLong(actionRequest, "surveyId")));
                        }
                    }
                } else {
                    errors.add(new SubmissionError("You must be signed in to submit a survey."));
                }
            } else if (cmd.equalsIgnoreCase("saverecord")) {
                long suveyId = ParamUtil.getLong(actionRequest, "surveyId");
                String coralType = actionRequest.getParameter("coralType");
                String lightColor = actionRequest.getParameter("light_color_input");
                String darkColor = actionRequest.getParameter("dark_color_input");
                //TODO need validation here
                char lightLetter = lightColor.trim().charAt(0);
                int lightNumber = Integer.parseInt(lightColor.trim().charAt(1) + "");
                char darkLetter = darkColor.trim().charAt(0);
                int darkNumber = Integer.parseInt(darkColor.trim().charAt(1) + "");
                Survey survey = surveyDao.getById(suveyId);
                SurveyRecord record = new SurveyRecord(survey, coralType, lightLetter, lightNumber, darkLetter, darkNumber);
                surveyRecordDao.save(record);
                actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                actionResponse.setRenderParameter("selectedTab", "dataTab");
            } else if (cmd.equalsIgnoreCase("deleterecord")) {
                long suveyId = ParamUtil.getLong(actionRequest, "surveyId");
                long recordId = ParamUtil.getLong(actionRequest, "recordId");
                SurveyRecord surveyRec = surveyRecordDao.getById(recordId);
                surveyRecordDao.delete(surveyRec);
                actionResponse.setRenderParameter("surveyId", String.valueOf(suveyId));
                actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                actionResponse.setRenderParameter("selectedTab", "dataTab");
            }
        } catch (Exception ex) {
            errors.add(new SubmissionError("Your submission contains invalid data. Check all fields."));
            _log.error("Submission error ", ex);
        }


    }

    private void validateEmptyFields(String organisation, String organisationType, String country, String reefName, String latitudeStr, String longitudeStr, Date date, Date time, String weather, String temperatureStr, String activity) {
        List<String> emptyFields = new ArrayList<String>();
        if (organisation == null || organisation.trim().isEmpty()) {
            emptyFields.add("Organisation");
        }
        if (organisationType == null || organisationType.trim().isEmpty()) {
            emptyFields.add("Organisation Type");
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
        if (date == null || date.toString().trim().isEmpty()) {
            emptyFields.add("Date");
        }
        if (time == null || time.toString().trim().isEmpty()) {
            emptyFields.add("Time");
        }
        if (temperatureStr == null || temperatureStr.trim().isEmpty()) {
            emptyFields.add("Temperature");
        }
        if (weather == null || weather.trim().isEmpty()) {
            emptyFields.add("Weather");
        }
        if (activity == null || activity.trim().isEmpty()) {
            emptyFields.add("Activity");
        }

        if (!emptyFields.isEmpty()) {
            String fields = "";
            for (String field : emptyFields) {
                fields = fields + " " + field;
            }
            errors.add(new SubmissionError("Required field(s):" + fields));
        }
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
