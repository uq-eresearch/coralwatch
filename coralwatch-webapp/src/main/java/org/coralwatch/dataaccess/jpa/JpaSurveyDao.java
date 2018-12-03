package org.coralwatch.dataaccess.jpa;

import java.io.InputStream;
import java.io.Serializable;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.hibernate.CacheMode;
import org.hibernate.Query;
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
        return entityManagerSource.getEntityManager()
            .createQuery("SELECT o FROM Survey o ORDER BY date DESC")
            .getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<SurveyRecord> getSurveyRecords(Survey survey) {
        return entityManagerSource.getEntityManager()
            .createQuery("SELECT o FROM SurveyRecord o WHERE o.survey = :survey ORDER BY o.id")
            .setParameter("survey",
            survey).getResultList();
    }

    @Override
    public Survey getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager()
            .createQuery("SELECT o FROM Survey o WHERE o.id = :id")
            .setParameter("id", id)
            .getResultList();
        if (resultList.isEmpty()) { return null; }
        assert resultList.size() == 1 : "id should be unique";
        return (Survey) resultList.get(0);
    }

    @Override
    public ScrollableResults getSurveysIterator(Reef reef) {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        return entityManager.getSession()
            .createQuery("SELECT o FROM Survey o WHERE o.reef.id = :reefId ORDER BY date DESC")
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50)
            .setParameter("reefId", reef.getId())
            .scroll();
    }

    @Override
    public ScrollableResults getSurveysIterator() {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        return entityManager.getSession()
            .createQuery("SELECT o FROM Survey o ORDER BY date DESC")
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50)
            .scroll();
    }

    @Override
    public ScrollableResults getSurveysIteratorWithFilters(String country, String reefName, String group, String surveyor, String comment) {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        String queryString = "SELECT o FROM Survey o";
        boolean WHERE_was_used = false;
        if (StringUtils.isBlank(country) == false) {
            queryString += " WHERE LOWER(o.reef.country) LIKE '%" + country + "%'";
            WHERE_was_used = true;
        }
        if (StringUtils.isBlank(reefName) == false) {
            queryString += (WHERE_was_used ? " AND" : " WHERE") + " LOWER(o.reef.name) LIKE '%" + reefName + "%'";
            WHERE_was_used = true;
        }
        if (StringUtils.isBlank(group) == false) {
            queryString += (WHERE_was_used ? " AND" : " WHERE") + " LOWER(o.groupName) LIKE '%" + group + "%'";
            WHERE_was_used = true;
        }
        if (StringUtils.isBlank(surveyor) == false) {
            queryString += (WHERE_was_used ? " AND" : " WHERE") + " LOWER(o.creator.displayName) LIKE '%" + surveyor + "%'";
            WHERE_was_used = true;
        }
        if (StringUtils.isBlank(comment) == false) {
            queryString += (WHERE_was_used ? " AND" : " WHERE") + " LOWER(o.comments) LIKE '%" + comment + "%'";
            WHERE_was_used = true;
        }
        queryString += " ORDER BY date DESC";
        Query query = entityManager.getSession()
            .createQuery(queryString)
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50);
        return query.scroll();
    }

    @Override
    public ScrollableResults getSurveysForDojo(Reef reef, UserImpl surveyCreator) {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        String queryString =
            "SELECT" +
            " survey.creator.displayName," +
            " survey.date," +
            " survey.reef.name," +
            " survey.reef.country," +
            " count(surveyRecord)," +
            " survey.id," +
            " survey.reviewState," +
            " survey.groupName," +
            " survey.comments" +
            " FROM Survey survey" +
            " JOIN survey.dataset as surveyRecord";
        if (reef != null) {
            queryString += " WHERE survey.reef.id = :reefId";
        }
        if (surveyCreator != null) {
            queryString += ((reef != null) ? " AND" : " WHERE") + " survey.creator.id = :surveyCreatorId";
        }
        queryString += " GROUP BY survey.id, survey.date, survey.reviewState, survey.groupName, survey.comments, survey.creator.displayName, survey.reef.name, survey.reef.country";
        queryString += " ORDER BY survey.date DESC";
        Query query = entityManager.getSession()
            .createQuery(queryString)
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50);
        if (reef != null) {
            query.setParameter("reefId", reef.getId());
        }
        if (surveyCreator != null) {
            query.setParameter("surveyCreatorId", surveyCreator.getId());
        }
        return query.scroll();
    }

    @Override
    public int count(String country) {
      try {
        if(StringUtils.isBlank(country)) {
          return ((Number)entityManagerSource.getEntityManager().createQuery(
              "select count(id) from Survey").getSingleResult()).intValue();
        } else {
          return ((Number)entityManagerSource.getEntityManager().createNativeQuery(
              "select count(survey.id) from Survey inner join reef on survey.reef_id = reef.id"
              + " where reef.country = ?").setParameter(1, country).getSingleResult()).intValue();
        }
      } catch(Exception e) {
        e.printStackTrace();
        return 0;
      }
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<Survey> missingElevation() {
      return entityManagerSource.getEntityManager().createQuery(
          "SELECT o FROM Survey o WHERE o.elevation is null AND o.elevationStatus is null ").getResultList();
    }

    private String sql(final String name) {
      InputStream in = null;
      try {
        in = this.getClass().getClassLoader().getResourceAsStream(
            String.format("/org/coralwatch/sql/%s.sql", name));
        if(in == null) {
          throw new RuntimeException("named query %s not found");
        }
        return IOUtils.toString(in);
      } catch(Exception e) {
        throw new RuntimeException(String.format("failed to load query %s", name));
      } finally {
        if(in != null) {
          try {in.close();} catch (Exception e) {}
        }
      }
    }

    public Object bleachingRiskAll() {
      return entityManagerSource.getEntityManager().createNativeQuery(
          sql("bleaching-risk-all_new")).getResultList();
    }

    public Object bleachingRiskPast48Months() {
        return entityManagerSource.getEntityManager().createNativeQuery(
                sql("bleaching-risk-past-48-months_new")).getResultList();
    }

    public Object bleachingRiskPast12Months() {
        return entityManagerSource.getEntityManager().createNativeQuery(
                sql("bleaching-risk-past-12-months_new")).getResultList();
    }

    public Object bleachingRiskPast3Months() {
        return entityManagerSource.getEntityManager().createNativeQuery(
                sql("bleaching-risk-past-3-months_new")).getResultList();
    }
    
    @SuppressWarnings("unchecked")
    @Override
    public List<Survey> bleachingRiskMailer() {
      return entityManagerSource.getEntityManager().createNativeQuery(
          sql("bleaching-risk-mailer_new"), Survey.class).getResultList();
    }

}
