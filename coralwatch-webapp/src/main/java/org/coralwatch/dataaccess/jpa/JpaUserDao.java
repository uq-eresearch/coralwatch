package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import java.io.Serializable;
import java.util.List;

public class JpaUserDao extends JpaDao<UserImpl> implements UserDao , Serializable {

    public JpaUserDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Survey> getSurveyEntriesCreated(UserImpl userImpl) {

        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o " +
                "WHERE o.creator = :user " +
                "ORDER BY o.id").setParameter("user", userImpl).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<UserImpl> getAdministrators() {
        return entityManagerSource.getEntityManager().createQuery("SELECT v FROM AppUser v WHERE v.superUser = TRUE ORDER BY v.id").getResultList();
    }

    @Override
    public UserImpl getByEmail(String email) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM AppUser o WHERE o.email = :email")
                .setParameter("email", email).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "Email should be unique";
        return (UserImpl) resultList.get(0);
    }

    @Override
    public UserImpl getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM AppUser o WHERE o.id = :id")
                .setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "Email should be unique";
        return (UserImpl) resultList.get(0);
    }

}
