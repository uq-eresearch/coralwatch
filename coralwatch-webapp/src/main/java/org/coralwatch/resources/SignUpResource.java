package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.restlet.resource.Variant;

import java.util.Map;

/**
 * @autho alabri
 * Date: 21/05/2009
 * Time: 11:42:03 AM
 */
public class SignUpResource extends AbstractFreemarkerResource<User> {

    public SignUpResource() throws InitializationException {
        super();
        setContentTemplateName("signup.html");
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
