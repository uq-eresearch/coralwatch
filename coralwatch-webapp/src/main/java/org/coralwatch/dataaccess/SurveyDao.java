package org.coralwatch.dataaccess;

import java.util.List;

import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;

import au.edu.uq.itee.maenad.dataaccess.Dao;


public interface SurveyDao extends Dao<Survey> {
     List<SurveyRecord> getSurveyRecords(Survey survey);
}
