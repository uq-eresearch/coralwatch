package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;


public class KitRequestResource extends ModifiableEntityResource<KitRequest, KitRequestDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(KitRequestResource.class.getName());
    
    public KitRequestResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getKitRequestDao());
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
    }


    @Override
    protected void updateObject(KitRequest kitRequest, Form form) throws SubmissionException {
        updateRequest(kitRequest, form);
    }

    static void updateRequest(KitRequest kitRequest, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String dateStr = form.getFirstValue("dispatchdate").trim();
        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                Date date = df.parse(dateStr);
                kitRequest.setDispatchdate(date);
            } catch (ParseException ex) {
                errors.add(new SubmissionError("Kit sent date value supplied is invalid."));
            }
        }

        String notes = form.getFirstValue("notes");
        kitRequest.setNotes(notes);

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected void preDeleteHook(KitRequest kitRequest) {
        super.preDeleteHook(kitRequest);
        LOGGER.info("##### Deleted survey: " + kitRequest.getId() + " #####");
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return user.isSuperUser();
    }
}
