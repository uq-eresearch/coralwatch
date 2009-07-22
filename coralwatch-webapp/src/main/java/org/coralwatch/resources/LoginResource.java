package org.coralwatch.resources;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class LoginResource extends AbstractFreemarkerResource<UserImpl> {

    private Dao<UserImpl> userDao;

    public LoginResource() throws InitializationException {
        super();
        this.userDao = CoralwatchApplication.getConfiguration().getUserDao();
        setContentTemplateName("login.html");
        setModifiable(true);
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        Form form = getRequest().getResourceRef().getQueryAsForm();
        final String redirectUrl = form.getFirstValue("redirectUrl");
        datamodel.put("redirectUrl", redirectUrl);
    }


    @Override
    public void protectedAcceptRepresentation(Representation entity) throws ResourceException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        Form form = new Form(entity);
        String username = form.getFirstValue("username");
        if (username == null || username.isEmpty()) {
            errors.add(new SubmissionError("No username was provided"));
        }
        String password = form.getFirstValue("password");
        if (password == null || password.isEmpty()) {
            errors.add(new SubmissionError("No password was provided"));
        }
        List<UserImpl> userImpls = userDao.getAll();
        for (UserImpl userImpl : userImpls) {
            if (userImpl.getUsername().equals(username)) {
                if (BCrypt.checkpw(password, userImpl.getPasswordHash())) {
                    login(userImpl);
                }
                break;
            }
        }
        if (errors.isEmpty() && getCurrentUser() == null) {
            errors.add(new SubmissionError("Username or password are wrong"));
        }
        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
        String redirectUrl = form.getFirstValue("redirectUrl");
        if (redirectUrl != null) {
            getResponse().redirectSeeOther(redirectUrl);
        } else {
            getResponse().redirectSeeOther("/");
        }
    }


    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) throws ResourceException {
        return true;
    }

    @Override
    protected boolean postAllowed(UserImpl userImpl, Representation representation) {
        return true;
    }
}