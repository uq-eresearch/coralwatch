package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.restlet.resource.Variant;

import java.util.Map;

/**
 * @autho alabri
 * Date: 19/05/2009
 * Time: 4:22:12 PM
 */
public class GraphsResource extends AbstractFreemarkerResource<User> {

    public GraphsResource() throws InitializationException {
        super();
        setContentTemplateName("graphs.html");
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
