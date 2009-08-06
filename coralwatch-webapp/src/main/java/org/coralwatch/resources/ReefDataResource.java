package org.coralwatch.resources;

import java.util.Map;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.UserImpl;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.EntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;


public class ReefDataResource extends EntityResource<Reef, ReefDao, UserImpl> {

    public ReefDataResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getReefDao());
        setContentTemplateName("reefdata.html.ftl");
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
    	super.fillDatamodel(datamodel);
        datamodel.put("surveys", getDao().getSurveysByReef((Reef) datamodel.get(getTemplateObjectName())));
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}
