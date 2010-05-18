package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;

import java.util.List;


public interface SurveyDao extends Dao<Survey> {
    List<SurveyRecord> getSurveyRecords(Survey survey);

    Survey getById(Long id);

    List<Survey> getSurveyForReef(Long reefId);
}
