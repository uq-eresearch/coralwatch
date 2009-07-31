package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SurveyResource extends ModifiableEntityResource<Survey, SurveyDao, UserImpl> {
    private static final Logger LOGGER = Logger.getLogger(SurveyResource.class.getName());


    public SurveyResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyDao());
    }


    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
        Survey survey = (Survey) datamodel.get(getTemplateObjectName());
        datamodel.put("surveyRecs", getDao().getSurveyRecords(survey));
        datamodel.put("reefRecs", CoralwatchApplication.getConfiguration().getReefDao().getAll());
    }

    @Override
    protected void updateObject(Survey survey, Form form) throws SubmissionException {
        updateSurvey(survey, form);
    }

    static void updateSurvey(Survey survey, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String organisation = form.getFirstValue("organisation");
        if ((organisation == null) || organisation.isEmpty()) {
            errors.add(new SubmissionError("No organisation name was provided. Organisation name must be supplied."));
        } else {
            survey.setOrganisation(organisation);
        }

        String organisationType = form.getFirstValue("organisationType");
        if ((organisationType == null) || organisationType.isEmpty()) {
            errors.add(new SubmissionError("No organisation type was provided. Organisation type must be supplied."));
        } else {
            survey.setOrganisationType(organisationType);
        }

        String reefName = form.getFirstValue("reefName");
        if ((reefName == null) || reefName.isEmpty()) {
            errors.add(new SubmissionError("No reef name was provided. Reef name must be supplied."));
        } else {
            List<Reef> reefList = CoralwatchApplication.getConfiguration().getReefDao().getReef(reefName);
            if(!reefList.isEmpty()) {
                survey.setReef(reefList.get(0));
            } else {
                errors.add(new SubmissionError("The reef name you entered is not valid. Select a valid reef name."));
            }
        }

        String latitudeStr = form.getFirstValue("latitude");
        if (latitudeStr == null || latitudeStr.isEmpty()) {
            errors.add(new SubmissionError("No latitude value was provided. Latitude value must be supplied."));
        } else {
            try {
                float latitude = Float.parseFloat(latitudeStr);
                survey.setLatitude(latitude);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.INFO, "Faild to parse latitude. Value entered: " + latitudeStr, e);
                errors.add(new SubmissionError("Latitude value supplied is invalid."));
            }
        }

        String longitudeStr = form.getFirstValue("longitude");
        if (longitudeStr == null || longitudeStr.isEmpty()) {
            errors.add(new SubmissionError("No longitude value was provided. Longitude value must be supplied."));
        } else {
            try {
                float longitude = Float.parseFloat(longitudeStr);
                survey.setLongitude(longitude);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.INFO, "Faild to parse longitude. Value entered: " + longitudeStr, e);
                errors.add(new SubmissionError("Longitude value supplied is invalid."));
            }
        }

        String dateStr = form.getFirstValue("date").trim();
        if (dateStr == null || dateStr.isEmpty()) {
            errors.add(new SubmissionError("No survey date was provided. Survey Date must be supplied."));
        } else {
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                Date date = df.parse(dateStr);
                survey.setDate(date);
            } catch (ParseException ex) {
                errors.add(new SubmissionError("Date value supplied is invalid."));
            }
        }

        String timeStr = form.getFirstValue("time");
        if ((timeStr == null) || timeStr.isEmpty()) {
            errors.add(new SubmissionError("No time was provided. Time must be supplied."));
        } else {
            try {
                DateFormat df = new SimpleDateFormat("'T'HH:mm:ss");
                Date time = df.parse(timeStr);
                survey.setTime(time);
            } catch (ParseException ex) {
                LOGGER.log(Level.INFO, "Faild to parse time for survey. Time entered: " + timeStr, ex);
                errors.add(new SubmissionError("Time value supplied is invalid."));
            }
        }

        String weather = form.getFirstValue("weather");
        if ((weather == null) || weather.isEmpty()) {
            errors.add(new SubmissionError("No weather condition was provided. Weather condition must be supplied."));
        } else {
            survey.setWeather(weather);
        }

        String activity = form.getFirstValue("activity");
        if ((activity == null) || activity.isEmpty()) {
            errors.add(new SubmissionError("No activity was provided. Activity must be supplied."));
        } else {
            survey.setActivity(activity);
        }

        String temp = form.getFirstValue("temperature");
        if (temp == null || temp.isEmpty()) {
            errors.add(new SubmissionError("No temperature value was provided. Temperature value must be supplied."));
        } else {
            double temperature = Double.parseDouble(temp);
            survey.setTemperature(temperature);
        }

        String comments = form.getFirstValue("comments");
        survey.setComments(comments);


        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //Only logged in users and super users can edit profiles
        //Logged in users can only edit their own survey
        long id = Long.valueOf((String) getRequest().getAttributes().get("id"));
        Survey survey = getDao().load(id);
        return getAccessPolicy().getAccessLevelForInstance(userImpl, survey).canRead();
    }
}
