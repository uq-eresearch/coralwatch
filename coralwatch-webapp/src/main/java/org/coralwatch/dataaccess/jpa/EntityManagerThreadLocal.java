package org.coralwatch.dataaccess.jpa;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

public class EntityManagerThreadLocal {

  private final EntityManagerFactory emf;
  private final ThreadLocal<EntityManager> entityManagerTL = new ThreadLocal<EntityManager>();

  public EntityManagerThreadLocal(EntityManagerFactory emf) {
    this.emf = emf;
  }

  public EntityManager getOrCreateEntityManager() {
    // we lazily initialize in case the entity manager is not actually needed
    // by a request
    EntityManager entityManager = entityManagerTL.get();
    if (entityManager == null) {
        entityManager = emf.createEntityManager();
        entityManagerTL.set(entityManager);
    }
    return entityManager;
}

  public void closeEntityManager() {
    EntityManager entityManager = entityManagerTL.get();
    if (entityManager != null) {
      entityManagerTL.remove();
      assert entityManager.isOpen() :
        "Entity manager should only be closed here but must have been closed elsewhere";
      entityManager.close();
    }
  }
}
