package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.SurveyRecord;

public class JpaSurveyRecordDao extends JpaDao<SurveyRecord> implements SurveyRecordDao {
    public JpaSurveyRecordDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }
}
