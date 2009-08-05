package org.coralwatch.dataaccess.jpa;

import java.util.List;

import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;


public class JpaSurveyDao extends JpaDao<Survey> implements SurveyDao {
    public JpaSurveyDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<SurveyRecord> getSurveyRecords(Survey survey) {
        return entityManagerSource.getEntityManager().createNamedQuery("Survey.getData").setParameter("survey",
                survey).getResultList();
    }
}
