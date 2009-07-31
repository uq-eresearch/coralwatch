package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import freemarker.template.Configuration;
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
        KitRequest kitRequest = new KitRequest(currentUser);
        if (currentUser.getAddress() == null) {
            String address = form.getFirstValue("address");
            if ((address == null) || address.isEmpty()) {
                errors.add(new SubmissionError("No address was provided. Postal address must be suplied for kit request."));
            } else {
                kitRequest.setAddress(address);
            }
        }
        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        } else {
            try {
                Configuration cfg = Emailer.getEmailTemplateConfiguration();
                Map<String, Object> root = new HashMap<String, Object>();
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
                    root = new HashMap<String, Object>();
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
        //For access level on editing kitrequests see KitRequestResource.getAllowed
        //Only logged in users can request kits
        return userImpl != null;
    }
}
