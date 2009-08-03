package org.coralwatch.resources;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;

public class ReefListResource extends ModifiableListResource<Reef, ReefDao, UserImpl> {

    public ReefListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getReefDao(), true);
    }

    @Override
    protected Reef createObject(Form form) throws SubmissionException {
        Reef reef = new Reef();
        ReefResource.updateReef(reef, form);
        return reef;
    }

    @Override
    protected String getRedirectLocation(Reef reef) {
        return null;
    }

        @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        return userImpl.isSuperUser();
    }
}
