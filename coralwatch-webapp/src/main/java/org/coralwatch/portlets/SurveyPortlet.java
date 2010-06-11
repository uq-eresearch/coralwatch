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
import org.coralwatch.util.AppUtil;

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

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("survey-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        renderRequest.setAttribute("surveyDao", surveyDao);
        renderRequest.setAttribute("userDao", userDao);
        renderRequest.setAttribute("reefs", reefDao.getAll());
//        renderRequest.setAttribute("errors", errors);
        include(viewJSP, renderRequest, renderResponse);
    }

    @Override
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession();

        List<String> errors = new ArrayList<String>();

        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        _log.info("Command: " + cmd);
        try {
            UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
            if (currentUser != null) {
                if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
                    String organisation = actionRequest.getParameter("organisation");
                    String organisationType = actionRequest.getParameter("organisationType");
                    String country = actionRequest.getParameter("country");
                    String reefName = actionRequest.getParameter("reefName");
                    String latitudeStr = actionRequest.getParameter("latitude");
                    Float latitude = ParamUtil.getFloat(actionRequest, "latitude");
                    String longitudeStr = actionRequest.getParameter("longitude");
                    Float longitude = ParamUtil.getFloat(actionRequest, "longitude");
                    boolean isGpsDevice = ParamUtil.getBoolean(actionRequest, "isGpsDevice");
                    Date date = ParamUtil.getDate(actionRequest, "date", new SimpleDateFormat("yyyy-MM-dd"));
                    Date time = ParamUtil.getDate(actionRequest, "time", new SimpleDateFormat("'T'HH:mm:ss"));
                    String weather = actionRequest.getParameter("weather");
                    String temperatureStr = actionRequest.getParameter("temperature");
                    Double temperature = ParamUtil.getDouble(actionRequest, "temperature");
                    String activity = actionRequest.getParameter("activity");
                    String comments = actionRequest.getParameter("comments");

                    validateEmptyFields(errors, organisation, organisationType, country, reefName, latitudeStr, longitudeStr, date, time, weather, temperatureStr, activity);

                    if (errors.isEmpty()) {
                        Reef reef = reefDao.getReefByName(reefName);
                        if (reef == null) {
                            reef = new Reef(reefName, country);
                            reefDao.save(reef);
                        }
                        if (cmd.equals(Constants.ADD)) {
                            Survey survey = new Survey();
                            survey.setCreator(currentUser);
                            survey.setOrganisation(organisation);
                            survey.setOrganisationType(organisationType);
                            survey.setReef(reef);
                            survey.setQaState("Post Migration");
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
                            _log.info("Added survey");
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
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
                            _log.info("Edited survey");
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                        }
                    } else {
                        actionResponse.setRenderParameter(Constants.CMD, cmd);
                        actionRequest.setAttribute("errors", errors);
                        if (cmd.equals(Constants.EDIT)) {
                            actionResponse.setRenderParameter("surveyId", String.valueOf(ParamUtil.getLong(actionRequest, "surveyId")));
                        }
                    }
                } else if (cmd.equals(Constants.DELETE)) {
                    long suveyId = ParamUtil.getLong(actionRequest, "surveyId");
                    Survey survey = surveyDao.getById(suveyId);
                    List<SurveyRecord> surveyRecords = surveyDao.getSurveyRecords(survey);
                    for (SurveyRecord record : surveyRecords) {
                        record.getSurvey().getDataset().remove(record);
                        surveyRecordDao.delete(record);
                    }
                    surveyDao.delete(survey);
                    AppUtil.clearCache();
                }
            } else {
                errors.add("You must be signed in to submit a survey.");
                actionRequest.setAttribute("errors", errors);
                actionResponse.setRenderParameter(Constants.CMD, cmd);
            }

        } catch (Exception ex) {
            errors.add("Your submission contains invalid data. Check all fields.");
            actionRequest.setAttribute("errors", errors);
            actionResponse.setRenderParameter(Constants.CMD, cmd);
            _log.error("Submission error ", ex);
        }


    }

    private void validateEmptyFields(List<String> errors, String organisation, String organisationType, String country, String reefName, String latitudeStr, String longitudeStr, Date date, Date time, String weather, String temperatureStr, String activity) {
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
            errors.add("Required field(s):" + fields);
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
