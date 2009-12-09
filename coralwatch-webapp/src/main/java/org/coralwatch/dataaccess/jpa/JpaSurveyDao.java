package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;

import java.util.List;


public class JpaSurveyDao extends JpaDao<Survey> implements SurveyDao {
    public JpaSurveyDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<SurveyRecord> getSurveyRecords(Survey survey) {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM SurveyRecord o WHERE o.survey = :survey ORDER BY o.id").setParameter("survey",
                survey).getResultList();
    }
}
