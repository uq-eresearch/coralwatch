package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRating;
import org.coralwatch.model.UserImpl;

import javax.persistence.NoResultException;
import java.io.Serializable;

public class JpaSurveyRatingDao extends JpaDao<SurveyRating> implements SurveyRatingDao , Serializable {
    public JpaSurveyRatingDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public SurveyRating getSurveyRating(UserImpl rator, Survey survey) {
        try {
            SurveyRating surveyRating = (SurveyRating) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o FROM SurveyRating o " +
                            "WHERE o.rator = :rator " +
                            "AND o.survey = :survey")
                    .setParameter("rator", rator)
                    .setParameter("survey", survey)
                    .getSingleResult();
            return surveyRating;
        } catch (NoResultException ex) {
            return null;
        }
    }

    @Override
    public double getCommunityRatingValue(Survey survey) {
        try {
            Double ratingValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT avg(o.ratingValue) FROM SurveyRating o WHERE o.survey = :survey").setParameter("survey", survey).getSingleResult();
            return ratingValue == null ? -1 : ratingValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    public double getRatingValueByUser(UserImpl rator, Survey survey) {
        try {
            Double ratingValue = (Double) entityManagerSource.getEntityManager().createQuery(
                    "SELECT o.ratingValue FROM SurveyRating o " +
                            "WHERE o.rator = :rator " +
                            "AND o.survey = :survey")
                    .setParameter("rator", rator)
                    .setParameter("survey", survey)
                    .getSingleResult();
            return ratingValue == null ? -1 : ratingValue.doubleValue();
        } catch (NoResultException ex) {
            return -1;
        }
    }

    @Override
    public long getNumberOfRatingsForASurvey(Survey survey) {
        try {
            Long ratingValue = (Long) entityManagerSource.getEntityManager().createQuery(
                    "SELECT count(o) FROM SurveyRating o WHERE o.survey = :survey").setParameter("survey", survey).getSingleResult();
            return ratingValue == null ? 0 : ratingValue;
        } catch (NoResultException ex) {
            return 0;
        }
    }
}
