package org.coralwatch.dataaccess.jpa;

import java.io.Serializable;
import java.util.List;

import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.hibernate.CacheMode;
import org.hibernate.ScrollableResults;
import org.hibernate.ejb.HibernateEntityManager;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;


public class JpaSurveyDao extends JpaDao<Survey> implements SurveyDao, Serializable {
    public JpaSurveyDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Survey> getAll() {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o ORDER BY date DESC").getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<SurveyRecord> getSurveyRecords(Survey survey) {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM SurveyRecord o WHERE o.survey = :survey ORDER BY o.id").setParameter("survey",
                survey).getResultList();
    }

    @Override
    public Survey getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o WHERE o.id = :id").setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "id should be unique";
        return (Survey) resultList.get(0);

    }

    @Override
    public ScrollableResults getSurveysIterator() {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        return entityManager.getSession()
            .createQuery(
                "SELECT o\n" +
                "FROM Survey o\n" +
                "ORDER BY date DESC"
            )
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50)
            .scroll();
    }

    @Override
    public ScrollableResults getSurveysIterator(Reef reef) {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        return entityManager.getSession()
            .createQuery(
                "SELECT o\n" +
                "FROM Survey o\n" +
                "WHERE o.reef.id = :reefId\n" +
                "ORDER BY date DESC"
            )
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50)
            .setParameter("reefId", reef.getId())
            .scroll();
    }
}
