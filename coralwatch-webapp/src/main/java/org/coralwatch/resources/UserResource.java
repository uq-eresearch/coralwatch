package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
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
import java.util.Map;
import java.util.logging.Logger;


public class UserResource extends ModifiableEntityResource<UserImpl, UserDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());

    public UserResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getUserDao());
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
        UserImpl userImpl = (UserImpl) datamodel.get(getTemplateObjectName());
        datamodel.put("conductedSurveys", getDao().getSurveyEntriesCreated(userImpl));
    }

    @Override
    protected void updateObject(UserImpl userImpl, Form form) throws SubmissionException {
        updateUser(userImpl, form);
    }

    public static void updateUser(UserImpl userImpl, Form form) throws SubmissionException {
    	assert userImpl != null: "Can not update null user";
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String email = form.getFirstValue("signupEmail");
        if ((email == null) || email.isEmpty()) {
            errors.add(new SubmissionError("No email was provided. An email address must be supplied."));
        } else {
            userImpl.setEmail(email);
        }

        String newDisplayName = form.getFirstValue("signupDisplayName");
        if ((newDisplayName == null) || newDisplayName.length() < 6) {
            errors.add(new SubmissionError("No display name was provided. A display name of at least 6 characters must be supplied."));
        } else {
            userImpl.setDisplayName(newDisplayName);
        }

        String role = form.getFirstValue("role");
        if (role != null) {
            if (role.equalsIgnoreCase("member")) {
                userImpl.setSuperUser(false);
            } else if (role.equalsIgnoreCase("administrator")) {
                userImpl.setSuperUser(true);
            } else {
                errors.add(new SubmissionError("The role you entered is invalid. Role can be either User or Administrator."));
            }
        }


        String newPassword = form.getFirstValue("signupPassword");
        if ((newPassword != null) && (!newPassword.isEmpty())) {
            if (newPassword.length() < 6) {
                errors.add(new SubmissionError("No password was provided. A password of at least 6 characters must be supplied."));
            } else if (!newPassword.equals(form.getFirstValue("signupPassword2"))) {
                errors.add(new SubmissionError("Passwords don't match"));
            } else {
                userImpl.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            }
        }

        String occupation = form.getFirstValue("signupOccupation");
        userImpl.setOccupation(occupation == null ? "" : occupation);
        String address = form.getFirstValue("signupAddress");
        userImpl.setAddress(address == null ? "" : address);
        String country = form.getFirstValue("signupCountry");
        userImpl.setCountry(country == null ? "" : country);

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected void postUpdateHook(UserImpl userImpl) {
        if (getCurrentUser() != null && getCurrentUser().getId() == userImpl.getId()) {
            // hack to replace potentially stale user object
            login(userImpl);
        }
        super.postUpdateHook(userImpl);
    }
   
    @Override
    protected void preDeleteHook(UserImpl user) {
        super.preDeleteHook(user);
        LOGGER.info("Deleting user: " + user.getDisplayName());
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //Only logged in users and super users can edit profiles
        //Logged in users can only edit their own profile
        long id = Long.valueOf((String) getRequest().getAttributes().get("id"));
        UserDao dao = getDao();
        UserImpl userObj = dao.load(id);
        return getAccessPolicy().getAccessLevelForInstance(userImpl, userObj).canRead();
    }

}