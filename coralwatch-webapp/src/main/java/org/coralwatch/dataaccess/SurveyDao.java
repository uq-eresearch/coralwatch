package org.coralwatch.dataaccess;

import java.util.List;

import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.hibernate.ScrollableResults;

import au.edu.uq.itee.maenad.dataaccess.Dao;


public interface SurveyDao extends Dao<Survey> {
    List<SurveyRecord> getSurveyRecords(Survey survey);

    Survey getById(Long id);
    
    public ScrollableResults getSurveysIterator();
    public ScrollableResults getSurveysIterator(Reef reef);
    public ScrollableResults getSurveysForDojo(Reef reef, UserImpl surveyCreator);

    int count(String country);

    List<Survey> missingElevation();

    Object bleachingRiskAll();
    Object bleachingRiskPast48Months();
    Object bleachingRiskPast12Months();
    Object bleachingRiskPast3Months();
    
    List<Survey> bleachingRiskMailer();
}
