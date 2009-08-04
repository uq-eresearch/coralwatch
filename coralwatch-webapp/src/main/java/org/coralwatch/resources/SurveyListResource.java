package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class SurveyListResource extends ModifiableListResource<Survey, SurveyDao, UserImpl> {
    public SurveyListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyDao(), true);
    }

    @Override
    protected Survey createObject(Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String reefName = form.getFirstValue("reefName");
        if ((reefName == null) || reefName.isEmpty()) {
            errors.add(new SubmissionError("No reef name was provided. Reef name must be supplied."));
        } else {
            Reef reef = CoralwatchApplication.getConfiguration().getReefDao().getReefByName(reefName);
            if (reef == null) {
                String country = form.getFirstValue("country");
                if ((country == null) || country.isEmpty()) {
                    errors.add(new SubmissionError("No country name was provided. Country name must be supplied."));
                } else {
                    Reef newReef = new Reef(reefName, country);
                    CoralwatchApplication.getConfiguration().getReefDao().save(newReef);
                }
            }
        }
        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        } else {
            Survey survey = new Survey();
            survey.setCreator(getCurrentUser());
            SurveyResource.updateSurvey(survey, form);
            return survey;
        }
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) {
        super.fillDatamodel(datamodel);
        datamodel.put("reefRecs", CoralwatchApplication.getConfiguration().getReefDao().getAll());
    }

    @Override
    protected String getRedirectLocation(Survey survey) {
        return String.valueOf("surveys/" + survey.getId());
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //For access level on editing surveys see SurveyResource.getAllowed
        //Only logged in users can create a new User
        return userImpl != null;
    }
}
