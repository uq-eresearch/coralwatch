package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.Emailer;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import javax.mail.MessagingException;
import java.util.ArrayList;
import java.util.List;

public class KitRequestListResource extends ModifiableListResource<KitRequest, KitRequestDao, UserImpl> {

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
                String messageToUser = "Hi " + currentUser.getDisplayName() + ",\n\nYour kit request has been submitted. An email has been sent to notify the CoralWatch administrators. Your kit will be sent to your address shortly.\n\nBest wishes,\nCoralWatch Team";
                String subjectToUser = "Kit Request Confirmation";
                Emailer.sendEmail(currentUser.getEmail(), "no-reply@coralwatch.org", subjectToUser, messageToUser);

                String subjectToAdmin = "New Kit Request";
                //Send email to administrators
                List<UserImpl> administrators = CoralwatchApplication.getConfiguration().getUserDao().getAdministrators();
                for (UserImpl admin : administrators) {
                    String messageToAdmin = "Hi " + admin.getDisplayName() + ",\n\n"+ currentUser.getDisplayName() + " has submitted a new kit request. An email has been sent to " + currentUser.getDisplayName() + " to confirm the kit request.\n\nBest wishes,\nCoralWatch Team";
                    Emailer.sendEmail(admin.getEmail(), "no-reply@coralwatch.org", subjectToAdmin, messageToAdmin);
                }
            } catch (MessagingException e) {
                e.printStackTrace();
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
        return true; //TODO fix this later
    }
}
