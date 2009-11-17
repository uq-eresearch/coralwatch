package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.TrustDao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;

public class TrustListResource extends ModifiableListResource<Trust, TrustDao, UserImpl> {

    public TrustListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getTrustDao(), true);
    }

    @Override
    protected Trust createObject(Form form) throws SubmissionException {
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
            trustValue = Double.valueOf(form.getFirstValue("trust"));
        } catch (NumberFormatException ex) {
            errors.add(new SubmissionError("Can not parse trust value"));
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }

        Trust trust = CoralwatchApplication.getConfiguration().getTrustDao().getTrust(trustor, trustee);
        if (trust == null) {
            return new Trust(trustor, trustee, trustValue);
        } else {
            trust.setTrustValue(trustValue);
            return trust;
        }
    }

    @Override
    protected String getRedirectLocation(Trust trust) {
        return String.valueOf("users/" + trust.getTrustee().getId());
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
