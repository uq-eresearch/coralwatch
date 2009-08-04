package org.coralwatch.dataaccess;

import java.util.Date;
import java.util.List;

import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;

import au.edu.uq.itee.maenad.dataaccess.Dao;


public interface SurveyDao extends Dao<Survey> {
     List<SurveyRecord> getSurveyRecords(Survey survey);

    // TODO get rid of this method, its implementation and the underlying query once we don't need
    // it anymore. It is only for migration of the old database where the surveys are spread across
    // multiple rows.
     Survey getExactSurvey(UserImpl creator, String organisation, String organisationType, Reef reef,
              String weather, Date date, Date time, float latitude, float longitude, String activity,
              String comments);
}
