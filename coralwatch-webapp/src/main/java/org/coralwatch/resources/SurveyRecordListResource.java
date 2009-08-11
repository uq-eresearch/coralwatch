package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;

import java.util.ArrayList;
import java.util.List;

public class SurveyRecordListResource extends
		ModifiableListResource<SurveyRecord, SurveyRecordDao, UserImpl> {

	public SurveyRecordListResource() throws InitializationException {
		super(CoralwatchApplication.getConfiguration().getSurveyRecordDao(),
				true);
	}

	@Override
	protected SurveyRecord createObject(Form form) throws SubmissionException {

		List<SubmissionError> errors = new ArrayList<SubmissionError>();
		SurveyRecord surveyRecord = new SurveyRecord();

		long surveyId = -1;
		try {
			surveyId = Long.valueOf(form.getFirstValue("surveyId"));
		} catch (NumberFormatException e) {
			errors.add(new SubmissionError("Can not parse survey ID"));
		}
		Survey survey = CoralwatchApplication.getConfiguration().getSurveyDao()
				.load(surveyId);
		UserImpl user = getCurrentUser();
		if(user == null || !(survey.getCreator().equals(user) || user.isSuperUser())) {
			errors.add(new SubmissionError("Illegal Access: you do not own this survey"));
		}

		if (!errors.isEmpty()) {
			throw new SubmissionException(errors);
		}

		surveyRecord.setSurvey(survey);
		SurveyRecordResource.updateSurveyRecord(surveyRecord, form);
		
		return surveyRecord;
	}

	@Override
	protected String getRedirectLocation(SurveyRecord surveyRecord) {
		return String.valueOf("surveys/" + surveyRecord.getSurvey().getId());
	}
}
