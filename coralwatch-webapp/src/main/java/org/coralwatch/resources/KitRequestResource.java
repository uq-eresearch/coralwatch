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


public class KitRequestResource extends ModifiableEntityResource<KitRequest, KitRequestDao, UserImpl> {

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

        String comments = form.getFirstValue("comments");
        kitRequest.setComments(comments);

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return true; //TODO fix access control
    }
}
