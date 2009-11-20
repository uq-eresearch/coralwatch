package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.TrustDao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;

import javax.persistence.NoResultException;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class JpaTrustDao extends JpaDao<Trust> implements TrustDao {
    public JpaTrustDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Trust getTrust(UserImpl trustor, UserImpl trustee) {
        try {
            Trust trust = (Trust) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o FROM Trust o " +
                            "WHERE o.trustor = :trustor " +
                            "AND o.trustee = :trustee")
                    .setParameter("trustor", trustor)
                    .setParameter("trustee", trustee)
                    .getSingleResult();
            return trust;
        } catch (NoResultException ex) {
            return null;
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public double getTrustValueByUser(UserImpl trustor, UserImpl trustee) {
        try {
            Double trustValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o.trustValue FROM Trust o " +
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
                    "SELECT avg(o.trustValue) FROM Trust o WHERE o.trustee = :trustee").setParameter("trustee", trustee).getSingleResult();
            return trustValue == null ? -1 : trustValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    public Map<Long, Double> getCommunityTrustForAll() {
        Map<Long, Double> map = new TreeMap<Long, Double>();
        List<UserImpl> users = CoralwatchApplication.getConfiguration().getUserDao().getAll();
        for (UserImpl user : users) {
            map.put(user.getId(), getCommunityTrustValue(user));
        }
        return map;
    }
}