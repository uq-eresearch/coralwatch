package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;

import java.util.List;

public class JpaReefDao extends JpaDao<Reef> implements ReefDao {
    public JpaReefDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public Reef getReefByName(String name) {
        List<?> resultList = entityManagerSource.getEntityManager().createNamedQuery("Reef.getReef").setParameter(
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
        return entityManagerSource.getEntityManager().createNamedQuery("Reef.getSurveys").setParameter("reefId",
                reef.getId()).getResultList();
	}
}
