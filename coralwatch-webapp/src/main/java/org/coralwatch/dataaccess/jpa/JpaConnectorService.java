package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import org.restlet.resource.Representation;
import org.restlet.service.ConnectorService;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;


public class JpaConnectorService extends ConnectorService implements EntityManagerSource {

    private final EntityManagerFactory emf;
    private final ThreadLocal<EntityManager> entityManagerTL = new ThreadLocal<EntityManager>();

    public JpaConnectorService(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public EntityManager getEntityManager() {
        // we lazily initialize in case the entity manager is not actually needed
        // by a request
        EntityManager entityManager = entityManagerTL.get();
        if (entityManager == null) {
            entityManager = emf.createEntityManager();
            entityManagerTL.set(entityManager);
        }
        return entityManager;
    }

    @Override
    public void afterSend(Representation entity) {
        EntityManager entityManager = entityManagerTL.get();
        if (entityManager != null) {
            entityManagerTL.remove();
            assert entityManager.isOpen() :
                    "Entity manager should only be closed here but must have been closed elsewhere";
            entityManager.close();
        }
        super.afterSend(entity);
    }
}
