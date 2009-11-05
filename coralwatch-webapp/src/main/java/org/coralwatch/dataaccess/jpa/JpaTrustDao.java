package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.TrustDao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;

import javax.persistence.NoResultException;

public class JpaTrustDao extends JpaDao<Trust> implements TrustDao {
    public JpaTrustDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public double getTrustByUser(UserImpl trustor, UserImpl trustee) {
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
    public double getCommunityTrust(UserImpl trustee) {
        try {
            Double trustValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT avg(o.trustValue) FROM Trust o WHERE o.trustee = :trustee").setParameter("trustee", trustee).getSingleResult();
            return trustValue == null ? -1 : trustValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }
}