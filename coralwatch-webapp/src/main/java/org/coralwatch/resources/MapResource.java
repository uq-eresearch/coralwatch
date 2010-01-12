package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.coralwatch.app.CoralwatchApplication;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.Map;

public class MapResource extends AbstractFreemarkerResource<User> {
    public MapResource() throws InitializationException {
        super();
        setContentTemplateName("map/map.html.ftl");
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException, ResourceException {
        datamodel.put("extraHeadContent", "map/map-head.ftl");
        datamodel.put("surveys", CoralwatchApplication.getConfiguration().getSurveyDao().getAll());
        datamodel.put("users", CoralwatchApplication.getConfiguration().getUserDao().getAll());
        datamodel.put("reefList", CoralwatchApplication.getConfiguration().getReefDao().getAll());
        datamodel.put("initJSOnLoad", "true");
        datamodel.put("fullUI", true);
    }

    @Override
    protected boolean getAllowed(User user, Variant variant) {
        return true;
    }

}
