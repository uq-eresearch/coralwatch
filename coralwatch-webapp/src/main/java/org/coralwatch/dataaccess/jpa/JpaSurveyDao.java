package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;

import java.io.Serializable;
import java.util.List;


public class JpaSurveyDao extends JpaDao<Survey> implements SurveyDao , Serializable {
    public JpaSurveyDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<SurveyRecord> getSurveyRecords(Survey survey) {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM SurveyRecord o WHERE o.survey = :survey ORDER BY o.id").setParameter("survey",
                survey).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public Survey getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o WHERE o.id = :id").setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "id should be unique";
        return (Survey) resultList.get(0);

    }

}
