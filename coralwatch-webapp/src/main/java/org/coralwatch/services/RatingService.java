package org.coralwatch.services;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.UserRatingDao;
import org.coralwatch.model.Survey;

public class RatingService {
    private static Log LOGGER = LogFactoryUtil.getLog(RatingService.class);

    public static double rateSurvey(long surveyId) {
        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
        UserRatingDao userRatingDao = CoralwatchApplication.getConfiguration().getRatingDao();
        SurveyRatingDao suveyRatingDao = CoralwatchApplication.getConfiguration().getSurveyRatingDao();
        Survey survey = surveyDao.getById(surveyId);

        //Get rating based on the community rating
        double communityRating = suveyRatingDao.getCommunityRatingValue(survey);
        //Get rating based on surveyor rating
        double creatorRating = userRatingDao.getCommunityRatingValue(survey.getCreator());

        //Get rating based on amount of data
        double amountOfDataRating = 0;
        int numberOfRecords = surveyDao.getSurveyRecords(survey).size();
        //TODO this is an arbitrary evaluation, need to have a real metric here
        if (numberOfRecords < 50) {
            amountOfDataRating = numberOfRecords / 10;
        } else {
            amountOfDataRating = 5;
        }

        //Get rating based on completeness of the metadata
        double ratingOfCompleteness = 0;

        //Get rating based on consistency

        return 0;
    }

    public static double rateUser(long userId) {

        //Get community rating for this user

        //Get rating of user's data

        //Get rating of user's amount of data


        //Get rating of user's frequency of contribution

        //Get rating of user's role

        //Get rating of user's metadata

        return 0;
    }
}
