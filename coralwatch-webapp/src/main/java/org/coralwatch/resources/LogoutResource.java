package org.coralwatch.resources;

import java.util.Map;

import org.coralwatch.model.UserImpl;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;


public class LogoutResource extends AbstractFreemarkerResource<UserImpl> {

    public LogoutResource() throws InitializationException {
        super();
        setContentTemplateName("logout.html.ftl");
    }

    @Override
    public Representation protectedRepresent(Variant variant) throws ResourceException {
        logout();
        return super.protectedRepresent(variant);
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        // nothing to do
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        return true;
    }
}
