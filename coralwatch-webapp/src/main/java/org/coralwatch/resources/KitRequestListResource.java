package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.ObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.Emailer;
import org.restlet.data.Form;
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

public class KitRequestListResource extends ModifiableListResource<KitRequest, KitRequestDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(KitRequestListResource.class.getName());

    public KitRequestListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getKitRequestDao(), true);
    }

    @Override
    protected KitRequest createObject(Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        UserImpl currentUser = getCurrentUser();
        if (currentUser.getAddress() == null) {
            errors.add(new SubmissionError("CoralWatch cannot process your kit request because you have not set your address in your profile. Set your address from <a href=\"users/" + currentUser.getId() + "\">your profile</a>."));
        }
        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        } else {
            KitRequest kitRequest = new KitRequest();
            kitRequest.setRequester(currentUser);
            try {
                Configuration cfg = new Configuration();
                cfg.setTemplateLoader(new ClassTemplateLoader(this.getClass(), "/templates/email"));
                cfg.setObjectWrapper(ObjectWrapper.BEANS_WRAPPER);

//                cfg.setDirectoryForTemplateLoading(new File(""));
                cfg.setObjectWrapper(new DefaultObjectWrapper());
                Map root = new HashMap();
                root.put("currentUser", currentUser);
                Template temp = cfg.getTemplate("kitRequestUserEmail.ftl");
                StringWriter writer = new StringWriter();
                temp.process(root, writer);
                writer.flush();

                String subject = "Kit Request Confirmation";
                Emailer.sendEmail(currentUser.getEmail(), "no-reply@coralwatch.org", subject, writer.toString());

                subject = "New Kit Request";
                //Send email to administrators
                List<UserImpl> administrators = CoralwatchApplication.getConfiguration().getUserDao().getAdministrators();
                for (UserImpl admin : administrators) {
                    root = new HashMap();
                    root.put("currentUser", currentUser);
                    root.put("admin", admin);
                    temp = cfg.getTemplate("kitRequestAdminEmail.ftl");
                    writer = new StringWriter();
                    temp.process(root, writer);
                    writer.flush();
                    Emailer.sendEmail(admin.getEmail(), "no-reply@coralwatch.org", subject, writer.toString());
                }
            } catch (MessagingException ex) {
                LOGGER.log(Level.WARNING, "Faild to send email for kit request made by " + currentUser.getDisplayName(), ex);
            } catch (IOException ex) {
                LOGGER.log(Level.WARNING, "Faild to send email for kit request made by " + currentUser.getDisplayName(), ex);
            } catch (TemplateException ex) {
                LOGGER.log(Level.WARNING, "Faild to send email for kit request made by " + currentUser.getDisplayName(), ex);
            }
            return kitRequest;
        }
    }

    @Override
    protected String getRedirectLocation(KitRequest kitrequest) {
        return String.valueOf("kit/" + kitrequest.getId());
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //For access level on editing surveys see SurveyResource.getAllowed
        //Only logged in users can create a new User
//        return userImpl != null;
        return true; //TODO Fix access control later
    }
}
