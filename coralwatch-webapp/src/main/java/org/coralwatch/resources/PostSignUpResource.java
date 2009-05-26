package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import org.restlet.resource.Variant;

import java.util.Map;

/**
 * @autho alabri
 * Date: 26/05/2009
 * Time: 12:21:23 PM
 */
public class PostSignUpResource extends AbstractFreemarkerResource<User> {

    public PostSignUpResource() throws InitializationException {
        super();
        setContentTemplateName("postsignup.html");
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
