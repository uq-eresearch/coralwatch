package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;

public class SurveyRecordListResource extends ModifiableListResource<SurveyRecord, SurveyRecordDao, UserImpl> {

    public SurveyRecordListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyRecordDao(), true);
    }

    @Override
    protected SurveyRecord createObject(Form form) throws SubmissionException {
        SurveyRecord surveyRecord = new SurveyRecord();
        long id = Long.valueOf((String) getRequest().getAttributes().get("id"));
        Survey survey = CoralwatchApplication.getConfiguration().getSurveyDao().load(id);
        surveyRecord.setSurvey(survey);
        SurveyRecordResource.updateSurveyRecord(surveyRecord, form);
        return surveyRecord;
    }

    @Override
    protected String getRedirectLocation(SurveyRecord surveyRecord) {
        return String.valueOf("surveys/" + surveyRecord.getSurvey().getId());
    }
}
