package org.coralwatch.dataaccess.jpa;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.restlet.resource.Representation;
import org.restlet.service.ConnectorService;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;


public class JpaConnectorService extends ConnectorService implements EntityManagerSource , Serializable {

    private final EntityManagerThreadLocal emtl;

    public JpaConnectorService(EntityManagerThreadLocal emtl) {
        this.emtl = emtl;
    }

    public EntityManager getEntityManager() {
      return emtl.getOrCreateEntityManager();
    }

    @Override
    public void afterSend(Representation entity) {
      try {
        emtl.closeEntityManager();
      } finally {
        super.afterSend(entity);
      }
    }

}
