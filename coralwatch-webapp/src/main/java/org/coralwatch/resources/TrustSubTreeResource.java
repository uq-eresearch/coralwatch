package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.restlet.data.MediaType;
import org.restlet.data.Parameter;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class TrustSubTreeResource extends AbstractFreemarkerResource<UserImpl> {
    private long userId;

    public TrustSubTreeResource() throws InitializationException {
        super();
        setMainTemplateName("trustsubtree.json.ftl");
    }

    @Override
    protected List<Variant> getSupportedVariants() {
        return Arrays.asList(new Variant(MediaType.APPLICATION_JSON));
    }

    @Override
    protected Representation protectedRepresent(Variant variant) throws ResourceException {
        Parameter trusteeId = getQuery().getFirst("trusteeId");
        if (getQuery().getFirst("trusteeId") != null) {
            userId = Long.parseLong(trusteeId.getValue());
        }
        return super.protectedRepresent(variant);
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        datamodel.put("trustors", CoralwatchApplication.getConfiguration().getTrustDao().getTrustorsForUser(userId));
        datamodel.put("trusteeId", userId);
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}
