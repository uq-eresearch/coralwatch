package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;


public class SurveyRecordResource extends ModifiableEntityResource<SurveyRecord, SurveyRecordDao, UserImpl> {

    private static final Logger LOGGER = Logger.getLogger(SurveyRecordResource.class.getName());

    public SurveyRecordResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyRecordDao());
    }

    @Override
    protected void updateObject(SurveyRecord surveyRecord, Form form) throws SubmissionException {
        updateSurveyRecord(surveyRecord, form);
    }

    public static void updateSurveyRecord(SurveyRecord surveyRecord, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String coralType = form.getFirstValue("coralType");
        if ((coralType == null) || coralType.isEmpty()) {
            errors.add(new SubmissionError("No coral type was provided. Coral type must be supplied."));
        } else {
            surveyRecord.setCoralType(coralType);
        }

        char lightestLetter = form.getFirstValue("lightestLetter").trim().charAt(0);
        int lightestNumber = Integer.parseInt(form.getFirstValue("lightestNumber"));
        if (lightestLetter < 'B' || lightestLetter > 'E' || lightestNumber < 1 || lightestNumber > 6) {
            errors.add(new SubmissionError("Lightest colour code was not provided correctly. Colour code must be supplied."));
        } else {
            surveyRecord.setLightestLetter(lightestLetter);
            surveyRecord.setLightestNumber(lightestNumber);
        }

        char darkestLetter = form.getFirstValue("darkestLetter").trim().charAt(0);
        int darkestNumber = Integer.parseInt(form.getFirstValue("darkestNumber"));
        if (darkestLetter < 'B' || darkestLetter > 'E' || darkestNumber < 1 || darkestNumber > 6) {
            errors.add(new SubmissionError("Darkest colour code was not provided correctly. Colour code must be supplied."));
        } else {
            surveyRecord.setDarkestLetter(darkestLetter);
            surveyRecord.setDarkestNumber(darkestNumber);
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected void preDeleteHook(SurveyRecord surveyRecord) {
        super.preDeleteHook(surveyRecord);
        LOGGER.info("##### Deleted survey record: " + surveyRecord.getId() + " #####");
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) throws ResourceException {
        //Only logged in users and super users can edit profiles
        //Logged in users can only edit their own survey
        long id = Long.valueOf((String) getRequest().getAttributes().get("id"));
        SurveyRecord surveyRecord = getDao().load(id);
        return getAccessPolicy().getAccessLevelForInstance(userImpl, surveyRecord).canRead();

    }
}
