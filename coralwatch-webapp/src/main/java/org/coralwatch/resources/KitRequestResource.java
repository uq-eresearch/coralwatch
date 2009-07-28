package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AccessControlledResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;


public class KitRequestResource extends AccessControlledResource<UserImpl> {

    public KitRequestResource() throws InitializationException {
    }

    @Override
    protected Representation protectedRepresent(Variant variant) throws ResourceException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void protectedAcceptRepresentation(Representation entity) throws ResourceException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        Form form = getRequest().getEntityAsForm();


        if (errors.isEmpty()) {

        } else {
            throw new SubmissionException(errors);
        }
    }


    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return false;
    }
}
