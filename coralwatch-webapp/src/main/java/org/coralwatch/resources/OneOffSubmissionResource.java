package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AbstractFreemarkerResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.Emailer;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import javax.mail.MessagingException;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
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
        LOGGER.info("##### Redirect URL: " + redirectUrl + " #####");

        String email = form.getFirstValue("emailDataOnly");
        LOGGER.info("##### Email: " + email + " #####");
        if (email == null || email.isEmpty()) {
            errors.add(new SubmissionError("No email address was provided"));
        } else {
            UserImpl user = CoralwatchApplication.getConfiguration().getUserDao().getByEmail(email);
            if (user != null) {
                if (user.getPasswordHash() != null) {
                    errors.add(new SubmissionError("An account with the same email already exists. Use your credentials to login."));
                    throw new SubmissionException(errors);
                } else {
                    goToSurvey(user, redirectUrl);
                    return;
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
            goToSurvey(newUser, redirectUrl);
        }
    }

    private void goToSurvey(UserImpl newUser, String redirectUrl) {
        login(newUser);

        try {
            Configuration cfg = Emailer.getEmailTemplateConfiguration();
            Map<String, Object> root = new HashMap<String, Object>();
            Template temp = cfg.getTemplate("oneOffSubmissionUserEmail.ftl");
            StringWriter writer = new StringWriter();
            temp.process(root, writer);
            writer.flush();

            String subject = "Invitation to join CoralWatch";
            Emailer.sendEmail(newUser.getEmail(), "no-reply@coralwatch.org", subject, writer.toString());

        } catch (MessagingException ex) {
            LOGGER.log(Level.WARNING, "Failed to send email for kit request made by " + newUser.getDisplayName(), ex);
        } catch (IOException ex) {
            LOGGER.log(Level.WARNING, "Failed to send email for kit request made by " + newUser.getDisplayName(), ex);
        } catch (TemplateException ex) {
            LOGGER.log(Level.WARNING, "Failed to send email for kit request made by " + newUser.getDisplayName(), ex);
        }

        if (redirectUrl != null) {
            redirect(redirectUrl);
        } else {
            redirect("/");
        }
    }

    @Override
    protected void fillDatamodel(Map<String, Object> stringObjectMap) throws NoDataFoundException, ResourceException {

    }

    @Override
    protected boolean postAllowed(UserImpl userImpl, Representation representation) {
        return true;
    }
    

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return true;
    }
}
