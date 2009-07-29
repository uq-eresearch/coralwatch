package org.coralwatch.resources.testing;

import org.coralwatch.app.ApplicationContext;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.restlet.data.MediaType;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.StringRepresentation;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.AccessControlledResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;


public class ResetResource extends AccessControlledResource<UserImpl> {

    public ResetResource() throws InitializationException {
        super();
        assert CoralwatchApplication.getConfiguration().isTestSetup() : "A reset resource should only be used in test setups";
        getVariants().add(new Variant(MediaType.TEXT_PLAIN));
    }

    @Override
    public Representation protectedRepresent(Variant variant) throws ResourceException {
        ApplicationContext config = (ApplicationContext) CoralwatchApplication.getConfiguration();
        config.resetDatabase();
        logout();
        return new StringRepresentation("Data reset complete.", MediaType.TEXT_PLAIN);
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        return CoralwatchApplication.getConfiguration().isTestSetup();
    }
}
