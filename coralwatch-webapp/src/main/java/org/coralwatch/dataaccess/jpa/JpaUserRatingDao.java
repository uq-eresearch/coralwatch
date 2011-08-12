package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserRatingDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserRating;

import javax.persistence.NoResultException;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JpaUserRatingDao extends JpaDao<UserRating> implements UserRatingDao, Serializable {
    public JpaUserRatingDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public UserRating getRating(UserImpl rater, UserImpl rated) {
        try {
            UserRating userRating = (UserRating) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o FROM UserRating o " +
                            "WHERE o.rater = :rater " +
                            "AND o.rated = :rated")
                    .setParameter("rater", rater)
                    .setParameter("rated", rated)
                    .getSingleResult();
            return userRating;
        } catch (NoResultException ex) {
            return null;
        }
    }

    @Override
    public double getRatingValueByUser(UserImpl rater, UserImpl rated) {
        try {
            Double ratingValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o.trustValue FROM UserRating o " +
                            "WHERE o.rater = :rater " +
                            "AND o.rated = :rated")
                    .setParameter("rater", rater)
                    .setParameter("rated", rated)
                    .getSingleResult();
            return ratingValue == null ? -1 : ratingValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    public double getCommunityRatingValue(UserImpl rated) {
        try {
            Double ratingValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT avg(o.ratingValue) FROM UserRating o WHERE o.rated = :rated")
                    .setParameter("rated", rated).getSingleResult();
            return ratingValue == null ? -1 : ratingValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    public Map<Long, Double> getCommunityRatingForAll() {
        Map<Long, Double> map = new HashMap<Long, Double>();
        List<UserImpl> users = CoralwatchApplication.getConfiguration().getUserDao().getAll();
        for (UserImpl user : users) {
            double ratingValue = getCommunityRatingValue(user);
            map.put(user.getId(), ratingValue);
        }
        return map;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<UserImpl> getRatersForUser(long ratedId) {
        UserImpl rated = CoralwatchApplication.getConfiguration().getUserDao().getById(ratedId);
        try {
            List<UserImpl> raters = entityManagerSource.getEntityManager().createQuery(
                    "SELECT o.rater FROM UserRating o WHERE o.rated = :rated")
                    .setParameter("rated", rated).getResultList();
            return raters;
        } catch (NoResultException ex) {
            return null;
        }
    }
}