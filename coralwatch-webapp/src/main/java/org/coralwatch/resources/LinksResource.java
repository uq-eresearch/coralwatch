package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;

import java.util.Map;

import org.restlet.resource.Variant;

public class LinksResource  extends AbstractFreemarkerResource<User> {

    public LinksResource() throws InitializationException {
        super();
        setContentTemplateName("links.html.ftl");
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
