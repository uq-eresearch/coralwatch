package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserTrustDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserTrust;

import javax.persistence.NoResultException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JpaUserTrustDao extends JpaDao<UserTrust> implements UserTrustDao {
    public JpaUserTrustDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public UserTrust getTrust(UserImpl trustor, UserImpl trustee) {
        try {
            UserTrust userTrust = (UserTrust) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o FROM UserTrust o " +
                            "WHERE o.trustor = :trustor " +
                            "AND o.trustee = :trustee")
                    .setParameter("trustor", trustor)
                    .setParameter("trustee", trustee)
                    .getSingleResult();
            return userTrust;
        } catch (NoResultException ex) {
            return null;
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public double getTrustValueByUser(UserImpl trustor, UserImpl trustee) {
        try {
            Double trustValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o.trustValue FROM UserTrust o " +
                            "WHERE o.trustor = :trustor " +
                            "AND o.trustee = :trustee")
                    .setParameter("trustor", trustor)
                    .setParameter("trustee", trustee)
                    .getSingleResult();
            return trustValue == null ? -1 : trustValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public double getCommunityTrustValue(UserImpl trustee) {
        try {
            Double trustValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT avg(o.trustValue) FROM UserTrust o WHERE o.trustee = :trustee")
                    .setParameter("trustee", trustee).getSingleResult();
            return trustValue == null ? -1 : trustValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    public Map<Long, Double> getCommunityTrustForAll() {


//        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM UserTrust o ORDER BY o.trustValue").getResultList();

        Map<Long, Double> map = new HashMap<Long, Double>();
        List<UserImpl> users = CoralwatchApplication.getConfiguration().getUserDao().getAll();
        for (UserImpl user : users) {
            double trustValue = getCommunityTrustValue(user);
            map.put(user.getId(), trustValue);
        }


        return map;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<UserImpl> getTrustorsForUser(long trusteeId) {
        UserImpl trustee = CoralwatchApplication.getConfiguration().getUserDao().getById(trusteeId);
        try {
            List<UserImpl> trustors = entityManagerSource.getEntityManager().createQuery(
                    "SELECT o.trustor FROM UserTrust o WHERE o.trustee = :trustee")
                    .setParameter("trustee", trustee).getResultList();
            return trustors;
        } catch (NoResultException ex) {
            return null;
        }
    }
}