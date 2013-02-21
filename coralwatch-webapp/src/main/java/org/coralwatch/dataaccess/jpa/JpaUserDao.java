package org.coralwatch.dataaccess.jpa;

import java.io.Serializable;
import java.util.List;

import javax.persistence.NoResultException;

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
    public int count() {
        try {
            return ((Long)entityManagerSource.getEntityManager().createQuery(
                    "select count(*) from AppUser").getSingleResult()).intValue();
        } catch(Exception e) {
            return 0;
        }
    }
}
