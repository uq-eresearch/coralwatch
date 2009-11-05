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

    @Override
    @SuppressWarnings("unchecked")
    public List<UserImpl> getAdministrators() {
        return entityManagerSource.getEntityManager().createNamedQuery("User.getAdministrators").getResultList();
    }

    @Override
    public UserImpl getByEmail(String email) {
        List<?> resultList = entityManagerSource.getEntityManager().createNamedQuery("User.getUserByEmail")
                .setParameter("email", email).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "Email should be unique";
        return (UserImpl) resultList.get(0);
    }

}
