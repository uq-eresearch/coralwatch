package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserTrustDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserTrust;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;

public class UserTrustListResource extends ModifiableListResource<UserTrust, UserTrustDao, UserImpl> {

    public UserTrustListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getTrustDao(), true);
    }

    @Override
    protected UserTrust createObject(Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        UserImpl trustor = getCurrentUser();
        long trusteeId = -1;
        try {
            trusteeId = Long.valueOf(form.getFirstValue("trusteeId"));
        } catch (NumberFormatException e) {
            errors.add(new SubmissionError("Can not parse trustee ID"));
        }
        UserImpl trustee = CoralwatchApplication.getConfiguration().getUserDao().load(trusteeId);

        double trustValue = 0;
        try {
            trustValue = Double.valueOf(form.getFirstValue("trustValue"));
        } catch (NumberFormatException ex) {
            errors.add(new SubmissionError("Can not parse userTrust value"));
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }

        UserTrust userTrust = CoralwatchApplication.getConfiguration().getTrustDao().getTrust(trustor, trustee);
        if (userTrust == null) {
            return new UserTrust(trustor, trustee, trustValue);
        } else {
            userTrust.setTrustValue(trustValue);
            return userTrust;
        }
    }

    @Override
    protected String getRedirectLocation(UserTrust userTrust) {
        return String.valueOf("users/" + userTrust.getTrustee().getId());
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
