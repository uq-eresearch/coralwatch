package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.Emailer;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import javax.mail.MessagingException;

public class KitRequestListResource extends ModifiableListResource<KitRequest, KitRequestDao, UserImpl> {

    public KitRequestListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getKitRequestDao(), true);
    }

    @Override
    protected KitRequest createObject(Form form) throws SubmissionException {
        UserImpl currentUser = getCurrentUser();
        KitRequest kitRequest = new KitRequest();
        kitRequest.setRequester(currentUser);
        try {
            String message = "Hi " + currentUser.getDisplayName() + ",\nYour kit request has been submitted. An email has been sent to notify the CoralWatch administrator. Your kit will be sent to your address shortly.\n\nBest wishes,\nCoralWatch Team";
            String subject = "Kit Request Confirmation";
            Emailer.sendEmail(currentUser.getEmail(), "no-reply@coralwatch.org", subject, message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        return kitRequest;
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
        return true; //TODO fix this later
    }
}
