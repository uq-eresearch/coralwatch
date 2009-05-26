package org.coralwatch.resources;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.User;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @autho alabri
 * Date: 21/05/2009
 * Time: 11:42:03 AM
 */
public class SignUpResource extends AbstractFreemarkerResource<User> {

    private Dao<User> userDao;

    public SignUpResource() throws InitializationException {
        super();
        this.userDao = CoralwatchApplication.getConfiguration().getUserDao();
        setContentTemplateName("user_edit.html");
        setModifiable(true);
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        Form form = getRequest().getResourceRef().getQueryAsForm();
        final String redirectUrl = form.getFirstValue("redirectUrl");
        datamodel.put("redirectUrl", redirectUrl);
    }

    @Override
    protected void protectedAcceptRepresentation(Representation entity) throws ResourceException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        Form form = new Form(entity);
        String username = form.getFirstValue("username");
        if (username == null || username.isEmpty()) {
            errors.add(new SubmissionError("No username was provided."));
        }

        String displayName = form.getFirstValue("displayName");
        if (displayName == null || displayName.isEmpty()) {
            errors.add(new SubmissionError("No displayName was provided."));
        }

        String email = form.getFirstValue("email");
        if (email == null || email.isEmpty()) {
            errors.add(new SubmissionError("No email address was provided."));
        }

        String password = form.getFirstValue("password");
        if (password == null || password.isEmpty()) {
            errors.add(new SubmissionError("No password was provided."));
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        } else {
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setDisplayName(displayName);
            newUser.setEmail(email);
            newUser.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            newUser.setSuperUser(false);
            newUser.setRegistrationDate(new Date());
            userDao.save(newUser);
            String redirectUrl = form.getFirstValue("redirectUrl");
            if (redirectUrl != null) {
                getResponse().redirectSeeOther(redirectUrl);
            } else {
                getResponse().redirectSeeOther("/");
            }
        }

    }

    @Override
    protected boolean getAllowed(User user, Variant variant) {
        return true;
    }

    @Override
    protected boolean postAllowed(User user, Representation representation) {
        return true;
    }
}
