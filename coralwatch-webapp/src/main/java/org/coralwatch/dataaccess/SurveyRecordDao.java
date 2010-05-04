package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.SurveyRecord;

public interface SurveyRecordDao extends Dao<SurveyRecord> {
    SurveyRecord getById(Long id);
}
