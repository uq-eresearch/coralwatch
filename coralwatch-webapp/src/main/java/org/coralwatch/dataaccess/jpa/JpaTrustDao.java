package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.TrustDao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;

public class JpaTrustDao extends JpaDao<Trust> implements TrustDao {
    public JpaTrustDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }


    @Override
    @SuppressWarnings("unchecked")
    public double getCommunityTrust(UserImpl trustee) {
        Double trustValue = (Double) entityManagerSource.getEntityManager().createQuery(
                "SELECT avg(o.trustValue) FROM Trust o WHERE o.trustee = :trustee").setParameter("trustee", trustee).getSingleResult();
        return trustValue == null ? 0 : trustValue.doubleValue();
    }
}