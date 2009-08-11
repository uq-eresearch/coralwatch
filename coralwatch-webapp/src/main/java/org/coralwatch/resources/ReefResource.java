package org.coralwatch.resources;

import java.util.ArrayList;
import java.util.List;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;

public class ReefResource extends ModifiableEntityResource<Reef, ReefDao, UserImpl> {

    public ReefResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getReefDao());
    }

    @Override
    protected void updateObject(Reef reef, Form form) throws SubmissionException {
        updateReef(reef, form);
    }

    public static void updateReef(Reef reef, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String reefName = form.getFirstValue("name");
        if ((reefName == null) || reefName.isEmpty()) {
            errors.add(new SubmissionError("No reef name was provided. Reef name must be supplied."));
        } else {
            reef.setName(reefName);
        }

        String country = form.getFirstValue("country");
        if ((country == null) || country.isEmpty()) {
            errors.add(new SubmissionError("No country name was provided. Country name must be supplied."));
        } else {
            reef.setCountry(country);
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        return true;
    }
}
