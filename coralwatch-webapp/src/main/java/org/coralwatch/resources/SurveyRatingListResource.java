package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRating;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;

public class SurveyRatingListResource extends ModifiableListResource<SurveyRating, SurveyRatingDao, UserImpl> {

    public SurveyRatingListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyRatingDao(), true);
    }


    @Override
    protected SurveyRating createObject(Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        UserImpl rator = getCurrentUser();
        long surveyId = -1;
        try {
            surveyId = Long.valueOf(form.getFirstValue("trusteeId"));
        } catch (NumberFormatException e) {
            errors.add(new SubmissionError("Can not parse survey ID"));
        }
        Survey survey = CoralwatchApplication.getConfiguration().getSurveyDao().load(surveyId);

        double trustValue = 0;
        try {
            trustValue = Double.valueOf(form.getFirstValue("trustValue"));
        } catch (NumberFormatException ex) {
            errors.add(new SubmissionError("Can not parse userTrust value"));
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }

        SurveyRating userRating = CoralwatchApplication.getConfiguration().getSurveyRatingDao().getSurveyRating(rator, survey);
        if (userRating == null) {
            return new SurveyRating(rator, survey, trustValue);
        } else {
            userRating.setRatingValue(trustValue);
            return userRating;
        }
    }

    @Override
    protected String getRedirectLocation(SurveyRating surveyRating) {
        return String.valueOf("survey/" + surveyRating.getSurvey().getId());
    }

    @Override
    protected boolean postAllowed(UserImpl user, Representation representation) {
        return true;
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        return true;
    }
}
