package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.model.KitRequest;

public class JpaKitRequestDao extends JpaDao<KitRequest> implements KitRequestDao {
    public JpaKitRequestDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }
}