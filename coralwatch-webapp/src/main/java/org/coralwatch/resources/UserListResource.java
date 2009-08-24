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


public class UserListResource extends ModifiableListResource<UserImpl, UserDao, UserImpl> {

    public UserListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getUserDao(), true);
    }

    @Override
    protected UserImpl createObject(Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String displayName = form.getFirstValue("signupDisplayName");
        if ((displayName == null) || displayName.isEmpty()) {
            errors.add(new SubmissionError(("Display name must not be empty")));
        }


        String password = form.getFirstValue("signupPassword");
        if ((password == null) || password.length() < 6) {
            errors.add(new SubmissionError("A password of at least 6 characters needs to be given"));
        } else if (!password.equals(form.getFirstValue("signupPassword2"))) {
            errors.add(new SubmissionError("Passwords don't match"));
        }

        String country = form.getFirstValue("signupCountry");

        String email = form.getFirstValue("signupEmail");
        if ((email == null) || email.isEmpty()) {
            errors.add(new SubmissionError(("Email must not be empty")));
        } else {
            UserImpl user = CoralwatchApplication.getConfiguration().getUserDao().getByEmail(email);
			if (user != null) {
				if (user.getPasswordHash() != null) {
					errors.add(new SubmissionError(
							"An account with the same email already exists."));
				} else {
					UserResource.updateUser(user, form);
					return user;
				}
			}
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }

        UserImpl userImpl = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
        userImpl.setCountry(country == null ? "" : country);

        return userImpl;
    }

    @Override
    protected String getRedirectLocation(UserImpl object) {
        return String.valueOf("surveys?new");
    }

    @Override
    protected void postCreationHandle(UserImpl user) {
        login(user);
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
