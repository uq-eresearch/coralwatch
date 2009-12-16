package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRating;
import org.coralwatch.model.UserImpl;

public interface SurveyRatingDao extends Dao<SurveyRating> {

    SurveyRating getSurveyRating(UserImpl rator, Survey survey);

    double getRatingValueByUser(UserImpl rator, Survey survey);

    double getCommunityRatingValue(Survey survey);
}
