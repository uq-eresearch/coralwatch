package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRating;

public interface SurveyRatingDao extends Dao<SurveyRating> {
    double getCommunityRatingValue(Survey survey);
}
