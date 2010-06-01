package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;

import java.io.Serializable;
import java.util.List;

public class JpaReefDao extends JpaDao<Reef> implements ReefDao , Serializable {
    public JpaReefDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public List<Reef> getAll() {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o ORDER BY name").getResultList();
    }

    @Override
    public Reef getReefByName(String name) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o WHERE o.name = :name").setParameter(
                "name", name).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "The name of a reef should be unique";
        return (Reef) resultList.get(0);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Survey> getSurveysByReef(Reef reef) {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o WHERE o.reef.id = :reefId").setParameter("reefId",
                reef.getId()).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public Reef getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o WHERE o.id = :id").setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "id should be unique";
        return (Reef) resultList.get(0);

    }
}
