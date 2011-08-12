package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.UserReputationProfileDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserReputationProfile;

import java.io.Serializable;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: alabri
 * Date: 18/08/2010
 * Time: 10:45:41 AM
 * To change this template use File | Settings | File Templates.
 */
public class JpaUserReputationProfileDao extends JpaDao<UserReputationProfile> implements UserReputationProfileDao, Serializable {

    public JpaUserReputationProfileDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public UserReputationProfile getByRatee(UserImpl ratee) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM UserReputationProfile o WHERE o.ratee = :ratee")
                .setParameter("ratee", ratee).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "Ratee should be unique";
        return (UserReputationProfile) resultList.get(0);
    }
}
