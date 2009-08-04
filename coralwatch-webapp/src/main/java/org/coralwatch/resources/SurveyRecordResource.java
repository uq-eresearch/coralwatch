package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AccessControlledResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;


public class SurveyRecordResource extends AccessControlledResource<UserImpl> {
    private final SurveyDao surveyDao;
    private final SurveyRecordDao surveyRecordDao;

    public SurveyRecordResource() throws InitializationException {
        this.surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        this.surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        setModifiable(true);
    }

    @Override
    protected Representation protectedRepresent(Variant variant) throws ResourceException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void protectedAcceptRepresentation(Representation entity) throws ResourceException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        Form form = getRequest().getEntityAsForm();
        long surveyId = -1;
        try {
            surveyId = Long.valueOf(form.getFirstValue("surveyId"));
        } catch (NumberFormatException e) {
            errors.add(new SubmissionError("Can not parse survey ID"));
        }
        String coralType = form.getFirstValue("coralType");
        if ((coralType == null) || coralType.isEmpty()) {
            errors.add(new SubmissionError("No coral type was provided. Coral type must be supplied."));
        }

        char lightestLetter = form.getFirstValue("lightestLetter").trim().charAt(0);
        int lightestNumber = Integer.parseInt(form.getFirstValue("lightestNumber"));
        if (lightestLetter < 'B' || lightestLetter > 'E' || lightestNumber < 1 || lightestNumber > 6) {
            errors.add(new SubmissionError("Lightest colour code was not provided correctly. Colour code must be supplied."));
        }

        char darkestLetter = form.getFirstValue("darkestLetter").trim().charAt(0);
        int darkestNumber = Integer.parseInt(form.getFirstValue("darkestNumber"));
        if (darkestLetter < 'B' || darkestLetter > 'E' || darkestNumber < 1 || darkestNumber > 6) {
            errors.add(new SubmissionError("Darkest colour code was not provided correctly. Colour code must be supplied."));
        }

        if (errors.isEmpty()) {
            Survey survey = this.surveyDao.load(surveyId);
            SurveyRecord surveyRecord = new SurveyRecord(survey, coralType, lightestLetter, lightestNumber, darkestLetter, darkestNumber);
            this.surveyRecordDao.save(surveyRecord);
            redirect("/surveys/" + survey.getId());
        } else {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return false;
    }

    @Override
    protected boolean postAllowed(UserImpl user, Representation entity) {
        return true; //getAccessPolicy().getAccessLevelForClass(user, Ontology.class).canUpdate();
    }
}
