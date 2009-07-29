package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;

import org.coralwatch.app.CoralwatchApplication;
import org.restlet.resource.Variant;

import java.util.Map;

public class FrontpageResource extends AbstractFreemarkerResource<User> {

    public FrontpageResource() throws InitializationException {
        super();
        setContentTemplateName("index.html.ftl");
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        // we add the test mode flag to make it obvious if an application runs in test mode
        datamodel.put("testMode", CoralwatchApplication.getConfiguration().isTestSetup());
    }

    @Override
    protected boolean getAllowed(User user, Variant variant) {
        return true;
    }
}