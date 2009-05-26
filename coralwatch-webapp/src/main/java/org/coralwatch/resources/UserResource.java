package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.User;
import org.restlet.data.Form;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @autho alabri
 * Date: 26/05/2009
 * Time: 2:38:28 PM
 */
public class UserResource extends ModifiableEntityResource<User, UserDao, User> {

    public UserResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getUserDao());
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
//        User user = (User) datamodel.get(getTemplateObjectName());
    }

    @Override
    protected void updateObject(User user, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        String newDisplayName = form.getFirstValue("displayName");
        if ((newDisplayName == null) || newDisplayName.length() < 6) {
            errors.add(new SubmissionError("No display name was provided. A display name of at least 6 characters must be supplied."));
        } else {
            user.setDisplayName(newDisplayName);
        }
        String newPassword = form.getFirstValue("password");
        if ((newPassword != null) && (!newPassword.isEmpty())) {
            if (newPassword.length() < 6) {
                errors.add(new SubmissionError("No password was provided. A password of at least 6 characters must be supplied."));
            } else if (!newPassword.equals(form.getFirstValue("password2"))) {
                errors.add(new SubmissionError("Passwords don't match"));
            } else {
                user.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            }
        }

        String email = form.getFirstValue("email");
        if ((email == null) || email.isEmpty()) {
            errors.add(new SubmissionError("No email was provided. An email address must be supplied."));
        } else {
            user.setEmail(email);
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

}