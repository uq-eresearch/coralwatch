package org.coralwatch.resources;

import org.restlet.resource.Variant;

import java.util.Map;

import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;

public class AboutResource extends AbstractFreemarkerResource<User> {

    public AboutResource() throws InitializationException {
        super();
        setContentTemplateName("about.html.ftl");
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        // nothing to add
    }

    @Override
    protected boolean getAllowed(User user, Variant variant) {
        return true;
    }
}
