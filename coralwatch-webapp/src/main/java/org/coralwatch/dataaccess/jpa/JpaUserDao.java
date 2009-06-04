package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import java.util.List;


public class JpaUserDao extends JpaDao<UserImpl> implements UserDao {

    public JpaUserDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Survey> getSurveyEntriesCreated(UserImpl userImpl) {
        return entityManagerSource.getEntityManager().createNamedQuery("User.getConductedSurveys").setParameter("user",
                userImpl).getResultList();
    }
}
