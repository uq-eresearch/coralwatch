package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;

/**
 * @autho alabri
 * Date: 27/05/2009
 * Time: 4:48:11 PM
 */
public class SurveyResource extends ModifiableEntityResource<Survey, SurveyDao, UserImpl> {
    public SurveyResource(SurveyDao surveyDao) throws InitializationException {
        super(surveyDao);
    }

    @Override
    protected void updateObject(Survey survey, Form form) throws SubmissionException {
        //To change body of implemented methods use File | Settings | File Templates.
    }
}
