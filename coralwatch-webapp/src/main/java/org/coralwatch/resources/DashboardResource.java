package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;

import org.coralwatch.app.CoralwatchApplication;
import org.restlet.resource.Variant;

import java.util.Map;


public class DashboardResource extends AbstractFreemarkerResource<User> {

    public DashboardResource() throws InitializationException {
        super();
        setContentTemplateName("dashboard.html.ftl");
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        datamodel.put("testMode", CoralwatchApplication.getConfiguration().isTestSetup());
    }

    @Override
    protected boolean getAllowed(User user, Variant variant) {
        return (user != null);
    }
}
