package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;

import java.io.Serializable;
import java.util.List;

public class JpaKitRequestDao extends JpaDao<KitRequest> implements KitRequestDao, Serializable {
    public JpaKitRequestDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public KitRequest getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM KitRequest o WHERE o.id = :id").setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "id should be unique";
        return (KitRequest) resultList.get(0);

    }

    @Override
    @SuppressWarnings("unchecked")
    public List<KitRequest> getAll() {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM KitRequest o ORDER BY requestDate DESC").getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<KitRequest> getByRequester(UserImpl requester) {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM KitRequest o WHERE o.requester = :requester").setParameter("requester", requester).getResultList();
    }
}