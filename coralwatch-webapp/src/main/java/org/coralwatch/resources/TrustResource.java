package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.TrustDao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.util.logging.Logger;

public class TrustResource extends ModifiableEntityResource<Trust, TrustDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(TrustResource.class.getName());

    public TrustResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getTrustDao());
    }

    @Override
    protected void updateObject(Trust trust, Form form) throws SubmissionException {
//        updateSurveyRecord(surveyRecord, form);
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}
