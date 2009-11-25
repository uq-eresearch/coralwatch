package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRating;

import javax.persistence.NoResultException;

public class JpaSurveyRatingDao extends JpaDao<SurveyRating> implements SurveyRatingDao {
    public JpaSurveyRatingDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public double getCommunityRatingValue(Survey survey) {
        try {
            Double ratingValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT avg(o.trustValue) FROM SurveyRating o WHERE o.survey = :survey").setParameter("survey", survey).getSingleResult();
            return ratingValue == null ? -1 : ratingValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }
}
