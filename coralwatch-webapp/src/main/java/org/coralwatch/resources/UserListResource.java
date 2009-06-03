package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;

/**
 * @autho alabri
 * Date: 26/05/2009
 * Time: 3:37:01 PM
 */
public class UserListResource extends ModifiableListResource<UserImpl, UserDao, UserImpl> {

    public UserListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getUserDao(), true);
    }

    @Override
    protected UserImpl createObject(Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        String username = form.getFirstValue("username");
        if ((username == null) || username.isEmpty()) {
            errors.add(new SubmissionError(("Username must not be empty")));
        } else {
            for (UserImpl userImpl : getDao().getAll()) {
                if (username.equals(userImpl.getUsername())) {
                    errors.add(new SubmissionError("Username already exists"));
                }
            }
        }
        String displayName = form.getFirstValue("displayName");
        if ((displayName == null) || displayName.isEmpty()) {
            errors.add(new SubmissionError(("Display name must not be empty")));
        }

        String email = form.getFirstValue("email");
        if ((email == null) || email.isEmpty()) {
            errors.add(new SubmissionError(("Email must not be empty")));
        }

        String password = form.getFirstValue("password");
        if ((password == null) || password.length() < 6) {
            errors.add(new SubmissionError("A password of at least 6 characters needs to be given"));
        } else if (!password.equals(form.getFirstValue("password2"))) {
            errors.add(new SubmissionError("Passwords don't match"));
        }
        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
        return new UserImpl(username, displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
    }

    @Override
    protected String getRedirectLocation(UserImpl object) {
        return String.valueOf("users/" + object.getId());
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //For access level on editing users see UserResource.getAllowed
        //Any one can create a new User
        if (userImpl == null && getRequest().getResourceRef().getQueryAsForm().getFirst("new") != null) {
            return true;
        }
        //Only super user can see the list of users
        if (userImpl != null) {
            return true;
        }
        return false;
    }
}
