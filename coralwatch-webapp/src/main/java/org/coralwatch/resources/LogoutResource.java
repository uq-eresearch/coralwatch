package org.coralwatch.resources;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.User;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.Map;


public class LogoutResource extends AbstractFreemarkerResource<User> {

    private Dao<User> userDao;

    public LogoutResource() throws InitializationException {
        super();
        this.userDao = CoralwatchApplication.getConfiguration().getUserDao();
        setContentTemplateName("logout.html");
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
    protected boolean getAllowed(User user, Variant variant) {
        return true;
    }
}
