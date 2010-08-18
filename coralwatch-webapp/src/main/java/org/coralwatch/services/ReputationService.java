package org.coralwatch.services;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.*;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserReputationProfile;
import org.coralwatch.services.reputation.Criterion;
import org.coralwatch.util.AppUtil;

import java.util.HashMap;

public class ReputationService {
    private static Log LOGGER = LogFactoryUtil.getLog(ReputationService.class);
    private static UserReputationProfileDao userReputationProfileDao = CoralwatchApplication.getConfiguration().getReputationProfileDao();

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

    public static void calculateUserRating(UserImpl rater, UserImpl ratee, Criterion criterion) {
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            userReputationProfile = new UserReputationProfile(ratee);
            HashMap<UserImpl, Double> map = new HashMap<UserImpl, Double>();
            map.put(rater, criterion.getRatingValue());
            userReputationProfile.setRaters(map);
            userReputationProfileDao.save(userReputationProfile);
        } else {
            HashMap<UserImpl, Double> map = userReputationProfile.getRaters();
            map.put(rater, criterion.getRatingValue());
            userReputationProfileDao.update(userReputationProfile);
        }

        AppUtil.clearCache();
    }

    public static Double getOverAllRating(UserImpl ratee) {
        Double overAllRating = 0.0;
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            return 0.0;
        } else {
            HashMap<UserImpl, Double> raters = userReputationProfile.getRaters();
            int raterCount = raters.size();
//            Set<Double> systemRatings = userReputationProfile.getSystemRatings();
//            int systemRatingCount = systemRatings.size();
//            int totalCount = raterCount + systemRatingCount;
            for (UserImpl rater : raters.keySet()) {
                overAllRating = overAllRating + raters.get(rater);
            }

//            for (Double rating : systemRatings) {
//                overAllRating = overAllRating + rating;
//            }

//            return (overAllRating / totalCount);
            return (overAllRating / raterCount);
        }
    }


    public static Double getRaterRating(UserImpl rater, UserImpl ratee) {
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            return 0.0;
        } else {
            return userReputationProfile.getRaters().get(rater);
        }
    }
}
