package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserTrustDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserTrust;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.util.logging.Logger;

public class UserTrustResource extends ModifiableEntityResource<UserTrust, UserTrustDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(UserTrustResource.class.getName());

    public UserTrustResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getTrustDao());
    }

    @Override
    protected void updateObject(UserTrust userTrust, Form form) throws SubmissionException {
//        updateSurveyRecord(surveyRecord, form);
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}
