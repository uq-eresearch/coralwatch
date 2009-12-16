package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.model.SurveyRating;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.util.logging.Logger;

public class SurveyRatingResource extends ModifiableEntityResource<SurveyRating, SurveyRatingDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(UserTrustResource.class.getName());

    public SurveyRatingResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyRatingDao());
    }

    @Override
    protected void updateObject(SurveyRating surveyRating, Form form) throws SubmissionException {
//        updateSurveyRecord(surveyRecord, form);
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}