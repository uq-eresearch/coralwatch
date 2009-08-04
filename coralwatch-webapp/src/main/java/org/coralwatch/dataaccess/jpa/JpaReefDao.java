package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;

import java.util.List;

public class JpaReefDao extends JpaDao<Reef> implements ReefDao {
    public JpaReefDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Reef> getReef(String name) {
        return entityManagerSource.getEntityManager().createNamedQuery("Reef.getReef").setParameter("name", name)
                .getResultList();
    }
}
