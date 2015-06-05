package org.coralwatch.dataaccess.jpa;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.NoResultException;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;

public class JpaUserDao extends JpaDao<UserImpl> implements UserDao, Serializable {

    public JpaUserDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Survey> getSurveyEntriesCreated(UserImpl userImpl) {

        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o " +
                "WHERE o.creator = :user " +
                "ORDER BY o.id").setParameter("user", userImpl).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<Long, Long> getSurveyEntriesCreatedAll() {
        Map<Long, Long> result = new HashMap<Long, Long>();
        List<Object[]> rows = (List<Object[]>)entityManagerSource.getEntityManager().createNativeQuery(
                "select appuser.id, count(survey.id) as surveys from appuser left outer join" +
                " survey on (appuser.id = survey.creator_id) group by appuser.id order by appuser.id;")
            .getResultList();
        for(Object[] row : rows) {
            Long userId = ((Number)row[0]).longValue();
            Long surveys = ((Number)row[1]).longValue();
            result.put(userId, surveys);
        }
        return result;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<UserImpl> getAll() {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM AppUser o ORDER BY o.displayName").getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<UserImpl> getAdministrators() {
        return entityManagerSource.getEntityManager().createQuery("SELECT v FROM AppUser v WHERE v.superUser = TRUE ORDER BY v.id").getResultList();
    }

    @Override
    public UserImpl getByEmail(String email) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM AppUser o WHERE o.email = :email")
                .setParameter("email", email).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "Email should be unique";
        return (UserImpl) resultList.get(0);
    }

    @Override
    public UserImpl getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM AppUser o WHERE o.id = :id")
                .setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "Email should be unique";
        return (UserImpl) resultList.get(0);
    }

    @Override
    public Long getNumberOfSurveys(UserImpl user) {
        try {
            Long numberOfSurveys = (Long) entityManagerSource.getEntityManager().createQuery(
                    "SELECT COUNT(s.id) FROM Survey s WHERE s.creator = :user")
                    .setParameter("user", user).getSingleResult();
            return numberOfSurveys == null ? 0 : numberOfSurveys.longValue();
        } catch (NoResultException ex) {
            return -1L;
        }
    }

    @Override
    public UserImpl getHighestContributor(String country) {
      if(StringUtils.isNotBlank(country)) {
        try {
          Number userId = (Number)entityManagerSource.getEntityManager().createNativeQuery(
              "select survey.creator_id from survey inner join reef on survey.reef_id = reef.id" +
              " where reef.country = ? group by survey.creator_id order by count(survey.id) desc"
              ).setParameter(1, country).setMaxResults(1).getSingleResult();
          return userId != null?getById(userId.longValue()):null;
        } catch(Exception e) {
          e.printStackTrace();
          return null;
        }
      } else {
        return getHighestContributor();
      }
    }

    @SuppressWarnings("unchecked")
    @Override
    public UserImpl getHighestContributor() {
      List<Object> result = (List<Object>)entityManagerSource.getEntityManager().createNativeQuery(
          "select appuser.id from appuser, survey where appuser.id = survey.creator_id " +
          "group by appuser.id order by count(*) desc, appuser.id limit 1;").getResultList();
      if(result.isEmpty()) {
        return null;
      } else {
        return getById(((Number)result.get(0)).longValue());
      }
    }

    @Override
    public int count(String country) {
      try {
        if(StringUtils.isBlank(country)) {
          return ((Long)entityManagerSource.getEntityManager().createQuery(
              "select count(id) from AppUser").getSingleResult()).intValue();
        } else {
          return ((Long)entityManagerSource.getEntityManager().createQuery(
              "select count(id) from AppUser where country = ?").setParameter(
                  1, country).getSingleResult()).intValue();
        }
      } catch(Exception e) {
        return 0;
      }
    }
}
