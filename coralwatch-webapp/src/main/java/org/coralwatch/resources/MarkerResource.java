package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.restlet.data.MediaType;
import org.restlet.resource.Variant;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class MarkerResource extends AbstractFreemarkerResource<UserImpl> {

    public MarkerResource() throws InitializationException {
        super();
        setMainTemplateName("marker.xml.ftl");
    }

    @Override
    protected List<Variant> getSupportedVariants() {
        return Arrays.asList(new Variant(MediaType.APPLICATION_XML));
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        datamodel.put("surveys", CoralwatchApplication.getConfiguration().getSurveyDao().getAll());
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}
