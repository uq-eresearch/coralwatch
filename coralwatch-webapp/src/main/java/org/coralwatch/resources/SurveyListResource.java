package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableListResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

/**
 * @autho alabri
 * Date: 27/05/2009
 * Time: 4:55:18 PM
 */
public class SurveyListResource extends ModifiableListResource<Survey, SurveyDao, UserImpl> {
    public SurveyListResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyDao(), true);
    }

    @Override
    protected Survey createObject(Form form) throws SubmissionException {
        Survey survey = new Survey();
        survey.setCreator(getCurrentUser());
        SurveyResource.updateSurvey(survey, form);
        return survey;
    }

    @Override
    protected String getRedirectLocation(Survey survey) {
        return String.valueOf("surveys/" + survey.getId());
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //For access level on editing surveys see SurveyResource.getAllowed
        //Only logged in users can create a new User
        if (userImpl != null && getRequest().getResourceRef().getQueryAsForm().getFirst("new") != null) {
            return true;
        }
        //Only super user can see the list of surveys
        if (userImpl != null && getCurrentUser().isSuperUser()) {
            return true;
        }
        getCurrentUser();
        return false;
    }
}
