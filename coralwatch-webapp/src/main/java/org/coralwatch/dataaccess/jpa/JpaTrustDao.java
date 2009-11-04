package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.TrustDao;
import org.coralwatch.model.Trust;

public class JpaTrustDao extends JpaDao<Trust> implements TrustDao {
    public JpaTrustDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }
}