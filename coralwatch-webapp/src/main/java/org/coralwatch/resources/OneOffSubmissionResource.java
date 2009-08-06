package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;


public class OneOffSubmissionResource extends AbstractFreemarkerResource<UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(OneOffSubmissionResource.class.getName());

    public OneOffSubmissionResource() throws InitializationException {
        super();
        setModifiable(true);
    }


    @Override
    public void protectedAcceptRepresentation(Representation entity) throws ResourceException {

        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        Form form = new Form(entity);

        String redirectUrl = form.getFirstValue("surveyUrl");
        LOGGER.info("##### URL: " + redirectUrl + " #####");

        String email = form.getFirstValue("emailDataOnly");
        LOGGER.info("##### Email: " + email + " #####");
        if (email == null || email.isEmpty()) {
            errors.add(new SubmissionError("No email address was provided"));
        } else {
            for (UserImpl user : CoralwatchApplication.getConfiguration().getUserDao().getAll()) {
                if (email.equals(user.getEmail())) {
                    if (user.getPasswordHash() != null) {
                        errors.add(new SubmissionError("An account with the same email already exists. Use your credentials to login."));
                        break;
                    } else {
                        goToSurvey(user, redirectUrl);
                        break;
                    }
                }
            }
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        } else {
            UserImpl newUser = new UserImpl();
            newUser.setEmail(email);
            newUser.setDisplayName(email);
            newUser.setSuperUser(false);

            CoralwatchApplication.getConfiguration().getUserDao().save(newUser);

            //Send email to the user
            goToSurvey(newUser, redirectUrl);
        }
    }

    private void goToSurvey(UserImpl newUser, String redirectUrl) {
        login(newUser);
        LOGGER.info("##### Logged In #####");
        if (redirectUrl != null) {
            getResponse().redirectSeeOther(redirectUrl);
        } else {
            redirect("/");
        }
    }

    @Override
    protected void fillDatamodel(Map<String, Object> stringObjectMap) throws NoDataFoundException, ResourceException {

    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return true;
    }
}
