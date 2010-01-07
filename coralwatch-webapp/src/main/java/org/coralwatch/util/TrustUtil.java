package org.coralwatch.util;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.Survey;

public class TrustUtil {
    public static void evaluateSurveyTrust(Survey survey) {
        survey.setTotalRatingValue(CoralwatchApplication.getConfiguration().getSurveyRatingDao().getCommunityRatingValue(survey));
        survey.setNumberOfRatings(CoralwatchApplication.getConfiguration().getSurveyRatingDao().getNumberOfRatingsForASurvey(survey));
    }
}
