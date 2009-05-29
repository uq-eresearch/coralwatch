package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @autho alabri
 * Date: 27/05/2009
 * Time: 4:48:11 PM
 */
public class SurveyResource extends ModifiableEntityResource<Survey, SurveyDao, UserImpl> {


    public SurveyResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyDao());
    }


    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
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

        String country = form.getFirstValue("country");
        if ((country == null) || country.isEmpty()) {
            errors.add(new SubmissionError("No country name was provided. Country name must be supplied."));
        } else {
            survey.setCountry(country);
        }

        String reefName = form.getFirstValue("reefName");
        if ((reefName == null) || reefName.isEmpty()) {
            errors.add(new SubmissionError("No reef name was provided. Reef name must be supplied."));
        } else {
            survey.setReefName(reefName);
        }

        String latitudeStr = form.getFirstValue("latitude");
        if (latitudeStr == null || latitudeStr.isEmpty()) {
            errors.add(new SubmissionError("No latitude value was provided. Latitude value must be supplied."));
        } else {
            float latitude = Float.parseFloat(latitudeStr);
            survey.setLatitude(latitude);
        }

        String longitudeStr = form.getFirstValue("longitude");
        if (longitudeStr == null || longitudeStr.isEmpty()) {
            errors.add(new SubmissionError("No longitude value was provided. Longitude value must be supplied."));
        } else {
            float longitude = Float.parseFloat(longitudeStr);
            survey.setLongitude(longitude);
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

        String time = form.getFirstValue("time");
        if ((time == null) || time.isEmpty()) {
            errors.add(new SubmissionError("No time was provided. Time must be supplied."));
        } else {
            survey.setTime(time);
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
}
